module ExpensesListWidget.Commandes exposing (..)

import Task
import Http
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..), Sorting(..))
import ExpensesListWidget.Json exposing (fetchExpensesDecoder, deleteExpenseDecoder)


fetchExpenses : String -> Cmd InternalMsg
fetchExpenses url =
    Http.get fetchExpensesDecoder url
        |> Task.perform FetchExpensesFail FetchExpensesDone


fetchAllExpenses : Cmd InternalMsg
fetchAllExpenses =
    fetchExpenses "http://localhost:4000/expenses"


fetchExpensesBy : Sorting -> SortOrder -> Cmd InternalMsg
fetchExpensesBy sortBy sortOrder =
    let
        fieldname =
            case sortBy of
                SortingField fieldname ->
                    fieldname

                NoSorting ->
                    ""

        order =
            case sortOrder of
                Asc ->
                    "ASC"

                Desc ->
                    "DESC"
    in
        fetchExpenses ("http://localhost:4000/expenses?_sort=" ++ fieldname ++ "&_order=" ++ order)


deleteExpenseRequest : String -> Http.Request
deleteExpenseRequest url =
    { verb = "DELETE", headers = [], url = url, body = Http.empty }


deleteExpense : Int -> Cmd InternalMsg
deleteExpense expenseId =
    Http.send Http.defaultSettings (deleteExpenseRequest ("http://localhost:4000/expenses/" ++ (toString expenseId)))
        |> Http.fromJson deleteExpenseDecoder
        |> Task.perform DeleteExpenseFail DeleteExpenseDone
