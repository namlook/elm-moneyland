module ExpensesListWidget.Update exposing (..)

import ExpensesListWidget.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import ExpensesListWidget.Models exposing (ExpensesListWidget, SortOrder(..), Sorting(..))


switchOrder : ExpensesListWidget -> String -> SortOrder
switchOrder widget fieldname =
    case widget.sortBy of
        SortingField currentField ->
            if fieldname == currentField then
                if widget.order == Asc then
                    Desc
                else
                    Asc
            else
                Asc

        NoSorting ->
            Asc


update : InternalMsg -> ExpensesListWidget -> ( ExpensesListWidget, Cmd Msg )
update msg model =
    case msg of
        -- Edit expense ->
        -- no-op : passed to parent
        -- ( model, Cmd.none )
        ToggleSorting fieldname ->
            ( { model
                | sortBy = SortingField fieldname
                , order = switchOrder model fieldname
              }
            , Cmd.none
            )
