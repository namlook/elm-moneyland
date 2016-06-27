module ExpensesListWidget.Messages exposing (..)

import Types exposing (Expense)
import Task


type InternalMsg
    = ToggleSorting String


type OutMsg
    = Edit Expense


type Msg
    = ForSelf InternalMsg
    | ForParent OutMsg


never : Never -> a
never n =
    never n


generateParentMsg : OutMsg -> Cmd Msg
generateParentMsg outMsg =
    Task.perform never ForParent (Task.succeed outMsg)
