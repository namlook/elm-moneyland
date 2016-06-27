module ExpensesListWidget.Messages exposing (..)

import Types exposing (Expense)
import ExpensesListWidget.Models exposing (SortOrder)


type Msg
    = Edit Expense
    | ToggleSorting String
