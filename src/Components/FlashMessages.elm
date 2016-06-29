module Components.FlashMessages exposing (..)

import Html exposing (Html, div, text, p, i)
import Html.Attributes exposing (class, classList, hidden)
import Html.Events exposing (onClick)
import Time exposing (Time, second)


type MessageType
    = Error
    | Info
    | Success


type alias FlashMessage =
    { type' : MessageType
    , title : String
    , body : Maybe (Html Msg)
    , icon : Maybe String
    , dismissable : Bool
    , shownFor : Maybe Int
    }



-- type alias BasicFlash message =
--     { message | type' : MessageType, title : String }
--
--
-- type alias FlashMessage =
--     BasicFlash {}
--
--
-- type alias IconMessage =
--     BasicFlash { icon : String }
--
--
-- type alias DismissableMessage =
--     BasicFlash { dismissable : Bool }


type alias Model =
    List FlashMessage


type Msg
    = RemoveMessage FlashMessage
    | Tick Time


iconClass : Maybe String -> String
iconClass icon =
    case icon of
        Just name ->
            name

        Nothing ->
            ""


displayFlashMessage : FlashMessage -> Html Msg
displayFlashMessage message =
    div
        [ classList
            [ ( "ui", True )
            , ( "info", message.type' == Info )
            , ( "success", message.type' == Success )
            , ( "error", message.type' == Error )
            , ( "icon", message.icon /= Nothing )
            , ( "message", True )
            ]
        ]
        [ (if message.dismissable then
            i
                [ class "close icon"
                , onClick (RemoveMessage message)
                ]
                []
           else
            i [] []
          )
        , (if message.icon /= Nothing then
            i [ class <| (Maybe.withDefault "" message.icon) ++ " icon" ] []
           else
            text ""
          )
        , div [ class "content" ]
            [ div [ class "header" ] [ text message.title ]
            , (case message.body of
                Just body ->
                    body

                Nothing ->
                    text ""
              )
            ]
        ]


view : Model -> Html Msg
view model =
    div [ class "ui basic segment", hidden <| List.length model == 0 ] (List.map displayFlashMessage model)


initDefault : Model
initDefault =
    []


processShownFor : FlashMessage -> FlashMessage
processShownFor message =
    case message.shownFor of
        Just time ->
            { message | shownFor = Just (time - 1) }

        Nothing ->
            message


update : Msg -> Model -> ( Model, Cmd Msg )
update msg queue =
    case msg of
        RemoveMessage message ->
            ( List.filter (\m -> m /= message) queue, Cmd.none )

        Tick time ->
            let
                updatedQueue =
                    List.map processShownFor queue
                        |> List.filter (\m -> m.shownFor /= Just 0)
            in
                ( updatedQueue, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every second Tick
