module Models exposing (..)

import Expenses.Models exposing (Expense)
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import Date exposing (Date)


type alias Model =
    { expenses : List Expense
    , expenseFormWidget : ExpenseFormWidget
    }


string2date : String -> Date
string2date string =
    Result.withDefault (Date.fromTime 0) (Date.fromString string)


expenses : List Expense
expenses =
    [ Expense (Just 1) (string2date "2/5/2016") "Sushi shop" 34.8 [ "nico", "nath" ] "nico" [ "restaurant" ]
    , Expense (Just 2) (string2date "2/19/2016") "Bouilloire pour le thé (maxicoffee)" 49.99 [ "nico, nath" ] "nico" [ "geekerie" ]
    , Expense (Just 3) (string2date "2/1/2016") "Elkorado" 22.25 [ "nico, nath" ] "nico" [ "geekerie" ]
    , Expense (Just 4) (string2date "2/5/2016") "Cadeau Jaime: porte smartphone" 19.98 [ "nico, nath" ] "nico" [ "cadeau", "famille" ]
    , Expense (Just 5) (string2date "2/9/2016") "support de cables (amazon)" 2.8 [ "nico" ] "nico" [ "geekerie" ]
    , Expense (Just 6) (string2date "2/17/2016") "CrashPlan" 5.85 [ "nico" ] "nico" [ "geekerie" ]
    ]


initModel : Model
initModel =
    { expenses = expenses
    , expenseFormWidget = ExpenseFormWidgets.Models.initModel
    }
