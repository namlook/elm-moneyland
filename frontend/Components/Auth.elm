module Components.Auth exposing (..)

import Html exposing (Html, text, p, label, div, input, button)
import Html.Attributes exposing (type', class, hidden, placeholder, value, hidden)
import Html.Events exposing (onInput, onClick)
import Http
import Task
import Base64
import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode


type InternalMsg
    = LoginInputChanged String
    | PasswordInputChanged String
    | Submit FormModel
    | TaskLoginSucceed Credentials
    | TaskLoginFailed Http.Error


type OutMsg
    = LoginSucceed Credentials
    | LoginFailed Http.Error


type Msg
    = ForParent OutMsg
    | ForSelf InternalMsg


type alias Credentials =
    { login : String
    , token : String
    }


type Authentification
    = LoggedUser Credentials
    | Anonymous


type alias Model =
    { user : Authentification
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
                    [ labeledInput (ForSelf << LoginInputChanged) "login" "text" model.form.login
                    , labeledInput (ForSelf << PasswordInputChanged) "password" "password" model.form.password
                    , button
                        [ class "ui right floated primary button"
                        , onClick (ForSelf (Submit model.form))
                        ]
                        [ text "login" ]
                    ]
                , div [ class "ui clearing hidden divider" ] []
                ]
            ]


update : InternalMsg -> Model -> ( Model, Cmd Msg )
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
                ( model, Cmd.map ForSelf <| fetchToken form )

            TaskLoginSucceed credentials ->
                ( model, generateParentMsg <| LoginSucceed credentials )

            TaskLoginFailed error ->
                ( model, generateParentMsg <| LoginFailed error )



-- Translator


type alias TranslationDictionary parentMsg =
    { onInternalMessage : InternalMsg -> parentMsg
    , onLoginSucceed : Credentials -> parentMsg
    , onLoginFailed : Http.Error -> parentMsg
    }


type alias Translator parentMsg =
    Msg -> parentMsg


translator : TranslationDictionary parentMsg -> Translator parentMsg
translator { onInternalMessage, onLoginSucceed, onLoginFailed } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal

        ForParent (LoginSucceed credentials) ->
            onLoginSucceed credentials

        ForParent (LoginFailed error) ->
            onLoginFailed error


never : Never -> a
never n =
    never n


generateParentMsg : OutMsg -> Cmd Msg
generateParentMsg outMsg =
    Task.perform never ForParent (Task.succeed outMsg)



-- JSON


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


fetchToken : FormModel -> Cmd InternalMsg
fetchToken form =
    Http.send Http.defaultSettings (fetchTokenRequest form)
        |> Http.fromJson tokenDecoder
        |> Task.perform TaskLoginFailed TaskLoginSucceed
