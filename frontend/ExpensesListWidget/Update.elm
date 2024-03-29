module ExpensesListWidget.Update exposing (..)

import ExpensesListWidget.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import ExpensesListWidget.Models exposing (ExpensesListWidget, SortOrder(..), Sorting(..))
import Types exposing (Expense)
import Date
import ExpensesListWidget.Commandes exposing (fetchExpensesBy, deleteExpense, createExpense, updateExpense)
import ExpensesListWidget.Translator exposing (generateParentMsg)
import Components.Auth exposing (Authentification)


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


update : Authentification -> InternalMsg -> ExpensesListWidget -> ( ExpensesListWidget, Cmd Msg )
update auth msg model =
    case msg of
        Add expense ->
            case expense.id of
                Just expenseId ->
                    ( model, Cmd.map ForSelf <| updateExpense auth expenseId expense )

                Nothing ->
                    ( model, Cmd.map ForSelf <| createExpense auth expense )

        CreateExpenseFail error ->
            ( model, generateParentMsg (RemoteError error) )

        CreateExpenseDone expense ->
            ( model
            , Cmd.map ForSelf <| fetchExpensesBy auth model.sortBy model.order
            )

        UpdateExpenseFail error ->
            ( model, generateParentMsg (RemoteError error) )

        UpdateExpenseDone expense ->
            ( model
            , Cmd.map ForSelf <| fetchExpensesBy auth model.sortBy model.order
            )

        FetchExpensesDone expenses ->
            ( { model | expenses = expenses }, Cmd.none )

        FetchExpensesFail error ->
            ( model, generateParentMsg (RemoteError error) )

        Delete expense ->
            case expense.id of
                Just expenseId ->
                    ( model, Cmd.map ForSelf <| deleteExpense auth expenseId )

                Nothing ->
                    ( model, Cmd.none )

        DeleteExpenseFail error ->
            ( model, generateParentMsg (RemoteError error) )

        DeleteExpenseDone a ->
            ( model
            , Cmd.map ForSelf <| fetchExpensesBy auth model.sortBy model.order
            )

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
                    ( { model | sortBy = Debug.log "sortBy" sortBy, order = Debug.log "order" order }
                    , Cmd.map ForSelf (fetchExpensesBy auth sortBy order)
                    )
