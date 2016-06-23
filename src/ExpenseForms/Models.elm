module ExpenseForms.Models exposing (..)

import String
import Expenses.Models exposing (Expense)


type alias ExpenseForm =
    { id : String
    , title : String
    , date : String
    , amount : String
    , for : String
    , paidBy : String
    , categories : String
    }


type alias ExpenseFormWidget =
    { show : Bool
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
    { id = toString <| Maybe.withDefault -1 expense.id
    , title = expense.title
    , date = expense.date
    , amount = toString expense.amount
    , for = String.join ", " expense.for
    , paidBy = expense.paidBy
    , categories = String.join ", " expense.categories
    }


initModel : ExpenseFormWidget
initModel =
    { show = False
    , form = initExpenseForm
    }
