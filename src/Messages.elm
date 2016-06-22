module Messages exposing (..)

import Expenses.Messages
import ExpenseForms.Messages


type Msg
    = ExpensesMsg Expenses.Messages.Msg
    | ExpenseFormsMsg ExpenseForms.Messages.Msg
