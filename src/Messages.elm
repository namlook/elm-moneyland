module Messages exposing (..)

import ExpensesListWidget.Messages
import ExpenseFormWidgets.Messages
import Components.NavBar


type Msg
    = ExpensesMsg ExpensesListWidget.Messages.Msg
    | ExpenseFormsMsg ExpenseFormWidgets.Messages.Msg
    | NavBarMsg Components.NavBar.Msg
