module Main exposing (..)

import Html.App
import Models exposing (Model, initModel)
import Messages exposing (Msg(..))
import Views exposing (view)
import Update exposing (update)


init : ( Model, Cmd Msg )
init =
    ( initModel, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MAIN


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
