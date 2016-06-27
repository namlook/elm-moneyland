module ExpenseFormWidgets.Messages exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)


type InternalMsg
    = TitleChange String
    | AmountChange String
    | ForChange String
    | PaidByChange String
    | DateChange String
    | CategoriesChange String
    | Cancel
    | ToggleForm
    | Save ExpenseFormWidget


type OutMsg
    = SaveExpense ExpenseFormWidget


type Msg
    = ForParent OutMsg
    | ForSelf InternalMsg
