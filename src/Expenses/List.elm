module Expenses.List exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, tr, td, th, input, form, label)
import Html.Attributes exposing (class, type')
import Html.Events exposing (onClick)
import Expenses.Models exposing (Expense)
import Expenses.Messages exposing (Msg(..))


view : List Expense -> Html Msg
view expenses =
    div []
        [ table [ class "ui celled striped padded table" ]
            [ viewHeader [ "title", "date", "amount", "for", "paid by", "categories" ]
            , tbody []
                (List.map viewRow expenses)
            ]
        ]


viewHeader : List String -> Html Msg
viewHeader fields =
    thead []
        (List.map (\field -> th [] [ text field ]) fields)


viewRow : Expense -> Html Msg
viewRow expense =
    tr [ onClick <| Edit expense.id ]
        [ td [] [ text expense.title ]
        , td [] [ text <| toString expense.date ]
        , td [] [ text <| toString expense.amount ]
        , td [] [ text <| toString expense.for ]
        , td [] [ text <| toString expense.paidBy ]
        , td [] [ text <| toString expense.categories ]
        ]
