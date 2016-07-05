module Models exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import ExpensesListWidget.Models exposing (ExpensesListWidget)
import Components.FlashMessages as FlashMessages
import Components.Auth as Auth


type alias Model =
    { expensesListWidget : ExpensesListWidget
    , expenseFormWidget : ExpenseFormWidget
    , flashMessages : FlashMessages.Model
    , auth : Auth.Model
    }


initModel : Model
initModel =
    { expensesListWidget = ExpensesListWidget.Models.initDefault
    , expenseFormWidget = ExpenseFormWidgets.Models.initModel
    , flashMessages = FlashMessages.initDefault
    , auth = Auth.initDefault
    }
