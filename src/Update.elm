module Update exposing (..)

import Models exposing (Model)
import Messages exposing (Msg(..))
import Expenses.Update
import ExpenseForms.Update
import ExpenseForms.Messages as ExpenseFormMsg
import ExpenseForms.Models exposing (ExpenseForm)
import Expenses.Models exposing (Expense)
import String


toExpenseId : String -> Maybe Int
toExpenseId id =
    Result.toMaybe <| String.toInt id


form2expense : ExpenseForm -> Expense
form2expense form =
    { id = Just -1
    , title = form.title
    , date = form.date
    , amount = Result.withDefault 0 <| String.toFloat form.amount
    , for = String.split "," form.for
    , paidBy = form.paidBy
    , categories = String.split "," form.categories
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ExpensesMsg subMsg ->
            let
                ( updatedExpenses, cmd ) =
                    Expenses.Update.update subMsg model.expenses
            in
                ( { model | expenses = updatedExpenses }, Cmd.map ExpensesMsg cmd )

        ExpenseFormsMsg subMsg ->
            case subMsg of
                ExpenseFormMsg.Save form ->
                    let
                        ( updatedExpenseForm, cmd ) =
                            ExpenseForms.Update.update subMsg model.expenseForm
                    in
                        ( { model
                            | expenses = [ form2expense form ] ++ model.expenses
                            , expenseForm = updatedExpenseForm
                          }
                        , Cmd.map ExpenseFormsMsg cmd
                        )

                _ ->
                    let
                        ( updatedExpenseForm, cmd ) =
                            ExpenseForms.Update.update subMsg model.expenseForm
                    in
                        ( { model | expenseForm = updatedExpenseForm }, Cmd.map ExpenseFormsMsg cmd )
