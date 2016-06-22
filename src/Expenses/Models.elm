module Expenses.Models exposing (..)

-- import Date exposing (Date)


type alias User =
    String


type alias Category =
    String


type alias ExpenseId =
    Maybe Int


type alias Expense =
    { id : ExpenseId
    , date :
        String
        -- TODO Date
    , title : String
    , amount : Float
    , for : List User
    , paidBy : User
    , categories : List Category
    }
