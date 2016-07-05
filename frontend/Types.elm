module Types exposing (..)

import Date exposing (Date)


type Authentification credentials
    = LoggedUser credentials
    | Anonymous


type alias User =
    String


type alias Category =
    String


type alias ExpenseId =
    Maybe String


type alias Expense =
    { id : ExpenseId
    , date : Date
    , title : String
    , amount : Float
    , for : List User
    , paidBy : User
    , categories : List Category
    }
