module Messages exposing (..)

import ExpensesListWidget.Messages
import ExpenseFormWidgets.Messages
import Components.NavBar
import Types exposing (Expense)


type Msg
    = ExpensesListWidgetMsg ExpensesListWidget.Messages.InternalMsg
    | ExpenseFormsMsg ExpenseFormWidgets.Messages.Msg
    | NavBarMsg Components.NavBar.Msg
    | Edit Expense
