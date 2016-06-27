module Models exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import ExpensesListWidget.Models exposing (ExpensesListWidget)


type alias Model =
    { expensesListWidget : ExpensesListWidget
    , expenseFormWidget : ExpenseFormWidget
    }


initModel : Model
initModel =
    { expensesListWidget = ExpensesListWidget.Models.initDefault
    , expenseFormWidget = ExpenseFormWidgets.Models.initModel
    }
