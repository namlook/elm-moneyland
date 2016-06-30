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
    | Add Expense
    | CreateExpenseFail Http.Error
    | CreateExpenseDone Expense
    | UpdateExpenseFail Http.Error
    | UpdateExpenseDone Expense


type OutMsg
    = Edit Expense
    | RemoteError Http.Error


type Msg
    = ForSelf InternalMsg
    | ForParent OutMsg
