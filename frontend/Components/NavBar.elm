module Components.NavBar exposing (..)

import Html exposing (Html, div, a, text, i)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Components.Auth exposing (Authentification(Anonymous))


type Msg
    = AddExpense


view : Authentification -> Html Msg
view authentification =
    let
        rightMenuItems =
            if authentification == Anonymous then
                []
            else
                [ a [ class "item", onClick AddExpense ]
                    [ i [ class "plus icon" ] []
                    , text "Add expense"
                    ]
                ]
    in
        div [ class "ui top fixed inverted teal menu" ]
            [ div [ class "item" ] [ i [ class "shekel icon" ] [], text "Moneyland" ]
            , div [ class "right menu" ] rightMenuItems
            ]
