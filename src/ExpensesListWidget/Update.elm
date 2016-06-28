module ExpensesListWidget.Update exposing (..)

import ExpensesListWidget.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import ExpensesListWidget.Models exposing (ExpensesListWidget, SortOrder(..), Sorting(..))
import Types exposing (Expense)
import Date
import ExpensesListWidget.Remote exposing (fetchExpensesBy)


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


sortByField : String -> List Expense -> List Expense
sortByField fieldname list =
    case fieldname of
        "title" ->
            List.sortBy .title list

        "amount" ->
            List.sortBy .amount list

        "date" ->
            List.sortBy (Date.toTime << .date) list

        _ ->
            list


update : InternalMsg -> ExpensesListWidget -> ( ExpensesListWidget, Cmd Msg )
update msg model =
    case msg of
        FetchExpensesDone expenses ->
            ( { model | expenses = expenses }, Cmd.none )

        FetchExpensesFail error ->
            let
                _ =
                    Debug.log "fetch fail" error
            in
                ( model, Cmd.none )

        ToggleSorting fieldname ->
            if (List.all (\n -> n /= fieldname) [ "title", "amount", "date" ]) then
                ( model, Cmd.none )
            else
                let
                    sortBy =
                        SortingField fieldname

                    order =
                        switchOrder model fieldname
                in
                    ( { model | sortBy = sortBy, order = order }
                    , Cmd.map ForSelf (fetchExpensesBy fieldname order)
                    )
