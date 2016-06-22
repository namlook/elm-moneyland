module ExpenseForms.Models exposing (..)


type alias ExpenseForm =
    { id : String
    , title : String
    , date : String
    , amount : String
    , for : String
    , paidBy : String
    , categories : String
    }


initModel : ExpenseForm
initModel =
    { id = ""
    , title = ""
    , date = ""
    , amount = ""
    , for = ""
    , paidBy = ""
    , categories = ""
    }
