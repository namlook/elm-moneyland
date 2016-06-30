module ExpensesListWidget.Commandes exposing (..)

import Task
import Http
import Json.Encode
import Types exposing (Expense)
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..), Sorting(..))
import ExpensesListWidget.Json exposing (fetchExpensesDecoder, deleteExpenseDecoder, fetchExpenseDecoder, expenseEncoder)


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


createExpenseRequest : Expense -> Http.Request
createExpenseRequest expense =
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = "http://localhost:4000/expenses"
    , body = Http.string <| Json.Encode.encode 1 (expenseEncoder expense)
    }


createExpense : Expense -> Cmd InternalMsg
createExpense expense =
    Http.send Http.defaultSettings (createExpenseRequest expense)
        |> Http.fromJson fetchExpenseDecoder
        |> Task.perform CreateExpenseFail CreateExpenseDone


updateExpenseRequest : Int -> Expense -> Http.Request
updateExpenseRequest expenseId expense =
    { verb = "PUT"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = "http://localhost:4000/expenses/" ++ (toString expenseId)
    , body = Http.string <| Json.Encode.encode 1 (expenseEncoder expense)
    }


updateExpense : Int -> Expense -> Cmd InternalMsg
updateExpense expenseId expense =
    Http.send Http.defaultSettings (updateExpenseRequest expenseId expense)
        |> Http.fromJson fetchExpenseDecoder
        |> Task.perform UpdateExpenseFail UpdateExpenseDone


deleteExpenseRequest : String -> Http.Request
deleteExpenseRequest url =
    { verb = "DELETE", headers = [], url = url, body = Http.empty }


deleteExpense : Int -> Cmd InternalMsg
deleteExpense expenseId =
    Http.send Http.defaultSettings (deleteExpenseRequest ("http://localhost:4000/expenses/" ++ (toString expenseId)))
        |> Http.fromJson deleteExpenseDecoder
        |> Task.perform DeleteExpenseFail DeleteExpenseDone
