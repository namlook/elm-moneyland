module ExpenseFormWidgets.Messages exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)


type Msg
    = TitleChange String
    | AmountChange String
    | ForChange String
    | PaidByChange String
    | DateChange String
    | CategoriesChange String
    | Save ExpenseFormWidget
    | Cancel
    | ToggleForm
