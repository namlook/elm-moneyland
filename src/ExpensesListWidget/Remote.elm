module ExpensesListWidget.Remote exposing (..)

import Types exposing (Expense)
import Task
import Http
import Json.Decode as Decode exposing ((:=))
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..), Sorting(..))


-- import Json.Encode as Encode

import Date exposing (Date)


fetchExpenses : String -> Cmd InternalMsg
fetchExpenses url =
    Http.get collectionDecoder url
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


deleteExpenseDecoder : Decode.Decoder {}
deleteExpenseDecoder =
    Decode.succeed {}


collectionDecoder : Decode.Decoder (List Expense)
collectionDecoder =
    Decode.list recordDecoder


recordDecoder : Decode.Decoder Expense
recordDecoder =
    Decode.object7 Expense
        ("id" := Decode.maybe Decode.int)
        ("date" := Decode.customDecoder Decode.string Date.fromString)
        ("title" := Decode.string)
        ("amount" := Decode.float)
        ("for" := Decode.list Decode.string)
        ("paidBy" := Decode.string)
        ("categories" := Decode.list Decode.string)
