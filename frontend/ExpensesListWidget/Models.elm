module ExpensesListWidget.Models exposing (..)

import Types exposing (Expense)
import Date exposing (Date)


type SortOrder
    = Asc
    | Desc


type Sorting
    = SortingField String
    | NoSorting


type alias ExpensesListWidget =
    { expenses : List Expense
    , order : SortOrder
    , sortBy : Sorting
    }


string2date : String -> Date
string2date string =
    Result.withDefault (Date.fromTime 0) (Date.fromString string)


initDefault : ExpensesListWidget
initDefault =
    { expenses = []
    , order = Asc
    , sortBy = NoSorting
    }
