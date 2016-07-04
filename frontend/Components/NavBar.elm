module Components.NavBar exposing (..)

import Html exposing (Html, div, a, text, i)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type Msg
    = AddExpense


view : Html Msg
view =
    div [ class "ui top fixed inverted teal menu" ]
        [ div [ class "item" ] [ i [ class "shekel icon" ] [], text "Moneyland" ]
        , div [ class "right menu" ]
            [ a [ class "item", onClick AddExpense ]
                [ i [ class "plus icon" ] []
                , text "Add expense"
                ]
            ]
        ]
