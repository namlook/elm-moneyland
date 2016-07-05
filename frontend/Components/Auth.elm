module Components.Auth exposing (..)

import Html exposing (Html, text, p, label, div, input, button)
import Html.Attributes exposing (type', class, hidden, placeholder, value, hidden)
import Html.Events exposing (onInput, onClick)
import Http
import Task
import Base64
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Types exposing (Authentification(Anonymous, LoggedUser))


type Msg
    = LoginInputChanged String
    | PasswordInputChanged String
    | LoginSucceed Credentials
    | LoginFailed Http.Error
    | Submit FormModel


type alias Credentials =
    { login : String
    , token : String
    }



-- type Msg
--     = ForSelf InternalMsg
--     | ForParent OutMsg


type alias Model =
    { user : Authentification Credentials
    , form : FormModel
    , error : String
    }


type alias FormModel =
    { login : String
    , password : String
    }


initFormDefault : FormModel
initFormDefault =
    { login = "", password = "" }


initDefault : Model
initDefault =
    { user = Anonymous
    , form = initFormDefault
    , error = ""
    }


view : Model -> Html Msg
view model =
    let
        labeledInput inputMsg labelText fieldtype val =
            div [ class "field" ]
                [ label [] [ text labelText ]
                , input
                    [ type' fieldtype
                    , placeholder labelText
                    , onInput inputMsg
                    , value val
                    ]
                    []
                ]

        errorMessages explanation =
            div [ class "ui attached error message", hidden (explanation == "") ]
                [ div [ class "header" ] [ text "login failed" ]
                , p [] [ text "bad login or password" ]
                ]
    in
        div []
            [ errorMessages model.error
            , div [ class "ui attached form segment" ]
                [ div []
                    [ labeledInput (LoginInputChanged) "login" "text" model.form.login
                    , labeledInput (PasswordInputChanged) "password" "password" model.form.password
                    , button
                        [ class "ui right floated primary button"
                        , onClick (Submit model.form)
                        ]
                        [ text "login" ]
                    ]
                , div [ class "ui clearing hidden divider" ] []
                ]
            ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        form =
            model.form
    in
        case msg of
            LoginInputChanged login ->
                ( { model | form = { form | login = login } }, Cmd.none )

            PasswordInputChanged password ->
                ( { model | form = { form | password = password } }, Cmd.none )

            Submit form ->
                ( model, fetchToken form )

            LoginSucceed credentials ->
                ( { model | user = LoggedUser credentials }, Cmd.none )

            LoginFailed error ->
                ( { model
                    | error = toString error
                    , user = Anonymous
                  }
                , Cmd.none
                )


tokenDecoder : Decode.Decoder Credentials
tokenDecoder =
    Decode.object2 Credentials
        ("login" := Decode.string)
        ("token" := Decode.string)


formModelEncoder : FormModel -> Encode.Value
formModelEncoder form =
    Encode.object
        [ ( "login", Encode.string form.login )
        , ( "password", Encode.string form.password )
        ]


fetchTokenRequest : FormModel -> Http.Request
fetchTokenRequest form =
    let
        authDigest =
            (form.login ++ ":" ++ form.password)
                |> Base64.encode
                |> Result.withDefault ""
    in
        { verb = "POST"
        , headers =
            [ ( "Content-Type", "application/json" )
            , ( "Authorization", "Basic " ++ authDigest )
            ]
        , url = "/api/auth"
        , body = Http.string <| Encode.encode 1 (formModelEncoder form)
        }


fetchToken : FormModel -> Cmd Msg
fetchToken form =
    Http.send Http.defaultSettings (fetchTokenRequest form)
        |> Http.fromJson tokenDecoder
        |> Task.perform LoginFailed LoginSucceed
