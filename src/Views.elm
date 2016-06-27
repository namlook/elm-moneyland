module Views exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.App as App
import Models exposing (Model)
import Messages exposing (Msg(..))
import ExpensesListWidget.List
import ExpenseFormWidgets.Form
import Components.NavBar as NavBar


view : Model -> Html Msg
view model =
    div [ class "mainapp" ]
        [ App.map NavBarMsg NavBar.view
        , App.map ExpenseFormsMsg (ExpenseFormWidgets.Form.view model.expenseFormWidget)
        , App.map ExpensesMsg (ExpensesListWidget.List.view model.expensesListWidget)
        ]
