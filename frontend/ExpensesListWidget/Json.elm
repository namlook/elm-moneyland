module ExpensesListWidget.Json exposing (..)

import Json.Decode as Decode exposing ((:=))
import Json.Encode as Encode
import Types exposing (Expense, ExpenseId)
import Date exposing (Date)


deleteExpenseDecoder : Decode.Decoder {}
deleteExpenseDecoder =
    Decode.succeed {}


fetchExpensesDecoder : Decode.Decoder (List Expense)
fetchExpensesDecoder =
    Decode.list fetchExpenseDecoder


dateStringDecoder : Decode.Decoder Date
dateStringDecoder =
    Decode.customDecoder Decode.string Date.fromString


timeStringDecoder : Decode.Decoder Date
timeStringDecoder =
    Decode.customDecoder Decode.float (\n -> Ok (Date.fromTime n))


fetchExpenseDecoder : Decode.Decoder Expense
fetchExpenseDecoder =
    Decode.object7 Expense
        ("id" := Decode.maybe Decode.string)
        ("date" := Decode.oneOf [ dateStringDecoder, timeStringDecoder ])
        ("title" := Decode.string)
        ("amount" := Decode.float)
        ("for" := Decode.list Decode.string)
        ("paidBy" := Decode.string)
        ("categories" := Decode.list Decode.string)


expenseIdEncoder : ExpenseId -> Encode.Value
expenseIdEncoder id =
    case id of
        Nothing ->
            Encode.null

        Just value ->
            Encode.string value


expenseEncoder : Expense -> Encode.Value
expenseEncoder expense =
    Encode.object
        [ ( "id", expenseIdEncoder expense.id )
        , ( "date", Encode.float <| Date.toTime expense.date )
        , ( "title", Encode.string expense.title )
        , ( "amount", Encode.float expense.amount )
        , ( "for", Encode.list <| List.map Encode.string expense.for )
        , ( "paidBy", Encode.string expense.paidBy )
        , ( "categories", Encode.list <| List.map Encode.string expense.categories )
        ]
