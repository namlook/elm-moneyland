module Messages exposing (..)

import Expenses.Messages
import ExpenseForms.Messages
import Components.NavBar


type Msg
    = ExpensesMsg Expenses.Messages.Msg
    | ExpenseFormsMsg ExpenseForms.Messages.Msg
    | NavBarMsg Components.NavBar.Msg
