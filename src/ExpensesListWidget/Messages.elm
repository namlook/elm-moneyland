module ExpensesListWidget.Messages exposing (..)

import Types exposing (Expense)


type InternalMsg
    = ToggleSorting String


type OutMsg
    = Edit Expense


type Msg
    = ForSelf InternalMsg
    | ForParent OutMsg
