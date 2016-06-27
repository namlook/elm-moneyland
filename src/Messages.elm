module Messages exposing (..)

import ExpensesListWidget.Messages
import ExpenseFormWidgets.Messages
import Components.NavBar
import Types exposing (Expense)
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)


type Msg
    = ExpensesListWidgetMsg ExpensesListWidget.Messages.InternalMsg
    | ExpenseFormWidgetMsg ExpenseFormWidgets.Messages.InternalMsg
    | NavBarMsg Components.NavBar.Msg
    | Edit Expense
    | Save ExpenseFormWidget
