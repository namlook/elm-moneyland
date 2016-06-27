module ExpenseFormWidgets.Models exposing (..)

import String
import Types exposing (Expense)
import Date exposing (Date)


type alias ExpenseForm =
    { id : String
    , title : String
    , date : String
    , amount : String
    , for : String
    , paidBy : String
    , categories : String
    }


type OpenType
    = New
    | Edit


type Display a
    = Opened a
    | Closed


type alias ExpenseFormWidget =
    { show : Bool
    , display : Display OpenType
    , form : ExpenseForm
    }


initExpenseForm : ExpenseForm
initExpenseForm =
    { id = ""
    , title = ""
    , date = ""
    , amount = ""
    , for = ""
    , paidBy = ""
    , categories = ""
    }


monthNumber : Date -> Int
monthNumber date =
    case (Date.month date) of
        Date.Jan ->
            1

        Date.Feb ->
            2

        Date.Mar ->
            3

        Date.Apr ->
            4

        Date.May ->
            5

        Date.Jun ->
            6

        Date.Jul ->
            7

        Date.Aug ->
            8

        Date.Sep ->
            9

        Date.Oct ->
            10

        Date.Nov ->
            11

        Date.Dec ->
            12


toRFC3339 : Date -> String
toRFC3339 date =
    (toString <| Date.year date)
        ++ "-"
        ++ (String.padLeft 2 '0' <| toString <| monthNumber date)
        ++ "-"
        ++ (String.padLeft 2 '0' <| toString <| Date.day date)


expense2form : Expense -> ExpenseForm
expense2form expense =
    { id = toString <| Maybe.withDefault -1 expense.id
    , title = expense.title
    , date = toRFC3339 expense.date
    , amount = toString expense.amount
    , for = String.join ", " expense.for
    , paidBy = expense.paidBy
    , categories = String.join ", " expense.categories
    }


initModel : ExpenseFormWidget
initModel =
    { show = False
    , display = Closed
    , form = initExpenseForm
    }
