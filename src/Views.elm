module Views exposing (..)

import Html exposing (Html, div, text)
import Html.App
import Models exposing (Model)
import Messages exposing (Msg(..))
import Expenses.List
import ExpenseForms.Form


view : Model -> Html Msg
view model =
    div []
        [ Html.App.map ExpenseFormsMsg (ExpenseForms.Form.view model.expenseForm)
        , Html.App.map ExpensesMsg (Expenses.List.view model.expenses)
        ]
