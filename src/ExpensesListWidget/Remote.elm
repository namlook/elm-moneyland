module ExpensesListWidget.Remote exposing (..)

import Types exposing (Expense)
import Task
import Http
import Json.Decode as Decode exposing ((:=))
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..))


-- import Json.Encode as Encode

import Date exposing (Date)


fetchExpenses : String -> Cmd InternalMsg
fetchExpenses url =
    Http.get collectionDecoder url
        |> Task.perform FetchExpensesFail FetchExpensesDone


fetchAllExpenses : Cmd InternalMsg
fetchAllExpenses =
    fetchExpenses "http://localhost:4000/expenses"


fetchExpensesBy : String -> SortOrder -> Cmd InternalMsg
fetchExpensesBy fieldname sortOrder =
    let
        order =
            case sortOrder of
                Asc ->
                    "ASC"

                Desc ->
                    "DESC"
    in
        fetchExpenses ("http://localhost:4000/expenses?_sort=" ++ fieldname ++ "&_order=" ++ order)


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
