module ExpenseForms.Form exposing (..)

import Html exposing (Html, div, text, label, input, form, button)
import Html.Attributes exposing (class, type', placeholder, value)
import Html.Events exposing (onInput, onClick)
import ExpenseForms.Messages exposing (Msg(..))
import ExpenseForms.Models exposing (ExpenseForm)


labeledInput : (String -> Msg) -> String -> String -> String -> Html Msg
labeledInput inputMsg labelText fieldtype val =
    div [ class "field" ]
        [ label [] [ text labelText ]
        , input
            [ type' fieldtype
            , placeholder labelText
            , onInput inputMsg
            , value val
            ]
            []
        ]


view : ExpenseForm -> Html Msg
view model =
    div [ (class "ui form expense-form") ]
        [ div []
            [ labeledInput TitleChange "title" "text" model.title
            , labeledInput DateChange "date" "text" model.date
            , labeledInput AmountChange "amount" "number" model.amount
            , labeledInput ForChange "for" "text" model.for
            , labeledInput PaidByChange "paidBy" "text" model.paidBy
            , labeledInput CategoriesChange "categories" "text" model.categories
            , button
                [ class "ui right floated button"
                , onClick (Save model)
                ]
                [ text "save" ]
            ]
        , div [ class "ui clearing hidden divider" ] []
        ]
