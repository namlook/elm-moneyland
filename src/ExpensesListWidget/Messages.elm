module ExpensesListWidget.Messages exposing (..)

import Types exposing (Expense)
import Http


type InternalMsg
    = ToggleSorting String
    | FetchExpensesFail Http.Error
    | FetchExpensesDone (List Expense)


type OutMsg
    = Edit Expense
    | FetchExpensesFailed Http.Error


type Msg
    = ForSelf InternalMsg
    | ForParent OutMsg
