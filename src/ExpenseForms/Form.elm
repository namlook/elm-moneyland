module ExpenseForms.Form exposing (..)

import Html exposing (Html, Attribute, div, text, label, input, form, button, a, i)
import Html.Attributes exposing (class, type', placeholder, value, hidden, classList)
import Html.Events exposing (onInput, onClick)
import ExpenseForms.Messages exposing (Msg(..))
import ExpenseForms.Models exposing (ExpenseFormWidget)


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


uiLabeledButton : List (Attribute Msg) -> String -> String -> Html Msg
uiLabeledButton attributes iconName textLabel =
    button ([ class "ui right labeled icon button" ] ++ attributes)
        [ text textLabel
        , i [ class (iconName ++ " icon") ] []
        ]


uiToggleFormButton : Bool -> Html Msg
uiToggleFormButton showForm =
    button
        [ class "ui labeled basic icon button"
        , onClick ToggleForm
        ]
        [ text "add expense"
        , i [ class "icon plus" ] []
        ]


view : ExpenseFormWidget -> Html Msg
view model =
    div []
        [ div [ hidden (model.show) ] [ uiToggleFormButton model.show ]
        , div [ class "ui segment", hidden (not model.show) ]
            [ div [ (class "ui form expense-form") ]
                [ div []
                    [ labeledInput TitleChange "title" "text" model.form.title
                    , labeledInput DateChange "date" "text" model.form.date
                    , labeledInput AmountChange "amount" "number" model.form.amount
                    , labeledInput ForChange "for" "text" model.form.for
                    , labeledInput PaidByChange "paidBy" "text" model.form.paidBy
                    , labeledInput CategoriesChange "categories" "text" model.form.categories
                    , button
                        [ class "ui right floated button"
                        , onClick (Cancel)
                        ]
                        [ text "cancel" ]
                    , button
                        [ class "ui right floated primary button"
                        , onClick (Save model)
                        ]
                        [ text "save" ]
                    ]
                , div [ class "ui clearing hidden divider" ] []
                ]
            ]
        ]
