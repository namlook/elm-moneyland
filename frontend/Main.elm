module Main exposing (..)

import Html.App
import Models exposing (Model, initModel)
import Messages exposing (Msg(..))
import Views exposing (view)
import Update exposing (update)
import Subscriptions exposing (subscriptions)


init : ( Model, Cmd Msg )
init =
    -- ( initModel, Cmd.map ExpensesListWidgetMsg ExpensesListWidget.Commandes.fetchAllExpenses )
    ( initModel, Cmd.none )


main : Program Never
main =
    Html.App.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
