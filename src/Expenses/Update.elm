module Expenses.Update exposing (..)

import Expenses.Models exposing (Expense, ExpenseId)
import Expenses.Messages exposing (Msg(..))


update : Msg -> List Expense -> ( List Expense, Cmd Msg )
update msg expenses =
    case msg of
        Edit expenseId ->
            let
                _ =
                    Debug.log "edit expense" expenseId
            in
                ( expenses, Cmd.none )
