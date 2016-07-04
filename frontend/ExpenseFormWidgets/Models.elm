module ExpenseFormWidgets.Models exposing (..)

import String
import Types exposing (Expense)
import Exts.Date exposing (toRFC3339)


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


expense2form : Expense -> ExpenseForm
expense2form expense =
    { id = Maybe.withDefault "" expense.id
    , title = expense.title
    , date = toRFC3339 expense.date
    , amount = toString expense.amount
    , for = String.join ", " <| List.sort expense.for
    , paidBy = expense.paidBy
    , categories = String.join ", " <| List.sort expense.categories
    }


initModel : ExpenseFormWidget
initModel =
    { show = False
    , display = Closed
    , form = initExpenseForm
    }
