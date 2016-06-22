module ExpenseForms.Messages exposing (..)

import ExpenseForms.Models exposing (ExpenseForm)


type Msg
    = TitleChange String
    | AmountChange String
    | ForChange String
    | PaidByChange String
    | DateChange String
    | CategoriesChange String
    | Save ExpenseForm
