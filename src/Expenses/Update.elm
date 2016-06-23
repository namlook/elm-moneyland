module Expenses.Update exposing (..)

import Expenses.Models exposing (Expense, ExpenseId)
import Expenses.Messages exposing (Msg(..))


update : Msg -> List Expense -> ( List Expense, Cmd Msg )
update msg expenses =
    case msg of
        Edit expense ->
            ( expenses, Cmd.none )
