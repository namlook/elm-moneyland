module Messages exposing (..)

import Expenses.Messages
import ExpenseFormWidgets.Messages
import Components.NavBar


type Msg
    = ExpensesMsg Expenses.Messages.Msg
    | ExpenseFormsMsg ExpenseFormWidgets.Messages.Msg
    | NavBarMsg Components.NavBar.Msg
