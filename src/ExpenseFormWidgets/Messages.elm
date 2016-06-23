module ExpenseFormWidgets.Messages exposing (..)

import Expenses.Models exposing (Expense)
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)


type Msg
    = TitleChange String
    | AmountChange String
    | ForChange String
    | PaidByChange String
    | DateChange String
    | CategoriesChange String
    | UpdateForm Expense
    | Save ExpenseFormWidget
    | Cancel
    | ToggleForm