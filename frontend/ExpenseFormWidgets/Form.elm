module ExpenseFormWidgets.Form exposing (..)

import Html exposing (Html, Attribute, div, text, label, input, form, button, a, i)
import Html.Attributes exposing (class, type', placeholder, value, hidden, classList)
import Html.Events exposing (onInput, onClick, onSubmit, onWithOptions)
import ExpenseFormWidgets.Messages exposing (Msg(..), InternalMsg(..))
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import Json.Decode


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


view : ExpenseFormWidget -> Html Msg
view model =
    div []
        [ div [ class "ui segment", hidden (not model.show) ]
            [ form [ onSubmit (ForSelf (Save model)), class "ui form expense-form" ]
                [ div []
                    [ labeledInput (ForSelf << TitleChange) "title" "text" model.form.title
                    , labeledInput (ForSelf << DateChange) "date" "date" model.form.date
                    , labeledInput (ForSelf << AmountChange) "amount" "number" model.form.amount
                    , labeledInput (ForSelf << ForChange) "for" "text" model.form.for
                    , labeledInput (ForSelf << PaidByChange) "paidBy" "text" model.form.paidBy
                    , labeledInput (ForSelf << CategoriesChange) "categories" "text" model.form.categories
                    , button
                        [ class "ui right floated button"
                        , Json.Decode.succeed (ForSelf Cancel)
                            |> onWithOptions "click" { stopPropagation = True, preventDefault = True }
                        ]
                        [ text "cancel" ]
                    , button
                        [ class "ui right floated primary button"
                        , type' "submit"
                        ]
                        [ text "save" ]
                    ]
                , div [ class "ui clearing hidden divider" ] []
                ]
            ]
        ]
