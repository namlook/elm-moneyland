module ExpensesListWidget.Commandes exposing (..)

import Task
import Http
import Json.Encode
import Types exposing (Expense)
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..), Sorting(..))
import ExpensesListWidget.Json exposing (fetchExpensesDecoder, deleteExpenseDecoder, fetchExpenseDecoder, expenseEncoder)


expensesEndpoint : String
expensesEndpoint =
    "/api/expenses"


fetchExpenses : String -> Cmd InternalMsg
fetchExpenses url =
    Http.get fetchExpensesDecoder url
        |> Task.perform FetchExpensesFail FetchExpensesDone


fetchAllExpenses : Cmd InternalMsg
fetchAllExpenses =
    fetchExpenses expensesEndpoint


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
        fetchExpenses (expensesEndpoint ++ "?_sort=" ++ fieldname ++ "&_order=" ++ order)


createExpenseRequest : Expense -> Http.Request
createExpenseRequest expense =
    { verb = "POST"
    , headers = [ ( "Content-Type", "application/json" ) ]
    , url = expensesEndpoint
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
    , url = expensesEndpoint ++ (toString expenseId)
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
    Http.send Http.defaultSettings (deleteExpenseRequest (expensesEndpoint ++ (toString expenseId)))
        |> Http.fromJson deleteExpenseDecoder
        |> Task.perform DeleteExpenseFail DeleteExpenseDone
