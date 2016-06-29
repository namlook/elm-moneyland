module ExpensesListWidget.Json exposing (..)

import Json.Decode as Decode exposing ((:=))
import Types exposing (Expense)
import Date exposing (Date)


deleteExpenseDecoder : Decode.Decoder {}
deleteExpenseDecoder =
    Decode.succeed {}


fetchExpensesDecoder : Decode.Decoder (List Expense)
fetchExpensesDecoder =
    Decode.list fetchExpenseDecoder


fetchExpenseDecoder : Decode.Decoder Expense
fetchExpenseDecoder =
    Decode.object7 Expense
        ("id" := Decode.maybe Decode.int)
        ("date" := Decode.customDecoder Decode.string Date.fromString)
        ("title" := Decode.string)
        ("amount" := Decode.float)
        ("for" := Decode.list Decode.string)
        ("paidBy" := Decode.string)
        ("categories" := Decode.list Decode.string)
