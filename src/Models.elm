module Models exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import Expenses.Models exposing (ExpensesListWidget)


type alias Model =
    { expensesListWidget : ExpensesListWidget
    , expenseFormWidget : ExpenseFormWidget
    }


initModel : Model
initModel =
    { expensesListWidget = Expenses.Models.initDefault
    , expenseFormWidget = ExpenseFormWidgets.Models.initModel
    }
