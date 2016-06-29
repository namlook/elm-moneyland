module Models exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import ExpensesListWidget.Models exposing (ExpensesListWidget)
import Components.FlashMessages as FlashMessages


type alias Model =
    { expensesListWidget : ExpensesListWidget
    , expenseFormWidget : ExpenseFormWidget
    , flashMessages : FlashMessages.Model
    }


initModel : Model
initModel =
    { expensesListWidget = ExpensesListWidget.Models.initDefault
    , expenseFormWidget = ExpenseFormWidgets.Models.initModel
    , flashMessages = FlashMessages.initDefault
    }
