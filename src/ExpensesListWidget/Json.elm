module ExpensesListWidget.Json exposing (..)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Types exposing (Expense)
import Date exposing (Date)
import Time exposing (Time)


deleteExpenseDecoder : Decode.Decoder {}
deleteExpenseDecoder =
    Decode.succeed {}


fetchExpensesDecoder : Decode.Decoder (List Expense)
fetchExpensesDecoder =
    Decode.list fetchExpenseDecoder


dateStringDecoder =
    Decode.customDecoder Decode.string Date.fromString


timeStringDecoder =
    Decode.customDecoder Decode.float (\n -> Ok (Date.fromTime n))


fetchExpenseDecoder : Decode.Decoder Expense
fetchExpenseDecoder =
    Decode.object7 Expense
        ("id" := Decode.maybe Decode.int)
        ("date" := Decode.oneOf [ dateStringDecoder, timeStringDecoder ])
        ("title" := Decode.string)
        ("amount" := Decode.float)
        ("for" := Decode.list Decode.string)
        ("paidBy" := Decode.string)
        ("categories" := Decode.list Decode.string)


expenseEncoder expense =
    Encode.object
        [ ( "id", Encode.string <| toString expense.id )
        , ( "date", Encode.float <| Date.toTime expense.date )
        , ( "title", Encode.string expense.title )
        , ( "amount", Encode.float expense.amount )
        , ( "for", Encode.list <| List.map Encode.string expense.for )
        , ( "paidBy", Encode.string expense.paidBy )
        , ( "categories", Encode.list <| List.map Encode.string expense.categories )
        ]
