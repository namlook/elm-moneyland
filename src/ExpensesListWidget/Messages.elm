module ExpensesListWidget.Messages exposing (..)

import Types exposing (Expense)
import Http


type InternalMsg
    = ToggleSorting String
    | Delete Expense
    | FetchExpensesFail Http.Error
    | FetchExpensesDone (List Expense)
    | DeleteExpenseFail Http.Error
    | DeleteExpenseDone {}


type OutMsg
    = Edit Expense
    | RemoteError Http.Error


type Msg
    = ForSelf InternalMsg
    | ForParent OutMsg
