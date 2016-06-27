module Expenses.Messages exposing (..)

import Types exposing (Expense)
import Expenses.Models exposing (SortOrder)


type Msg
    = Edit Expense
    | ToggleSorting String
