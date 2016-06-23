module Update exposing (..)

import Models exposing (Model)
import Messages exposing (Msg(..))
import Expenses.Messages
import ExpenseForms.Update
import ExpenseForms.Messages
import ExpenseForms.Models exposing (ExpenseForm, expense2form)
import Expenses.Models exposing (Expense)
import Components.NavBar
import String


toExpenseId : String -> Maybe Int
toExpenseId id =
    Result.toMaybe <| String.toInt id


form2expense : ExpenseForm -> Expense
form2expense form =
    { id = Just <| Result.withDefault -1 <| String.toInt form.id
    , title = form.title
    , date = form.date
    , amount = Result.withDefault 0 <| String.toFloat form.amount
    , for = String.split "," form.for
    , paidBy = form.paidBy
    , categories = String.split "," form.categories
    }


updateExpenses : List Expense -> Expense -> List Expense
updateExpenses expenses newExpense =
    if List.any (\expense -> expense.id == newExpense.id) expenses then
        List.map
            (\expense ->
                if expense.id == newExpense.id then
                    newExpense
                else
                    expense
            )
            expenses
    else
        newExpense :: expenses


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NavBarMsg subMsg ->
            case subMsg of
                Components.NavBar.AddExpense ->
                    let
                        ( updatedModel, cmd ) =
                            ExpenseForms.Update.update ExpenseForms.Messages.ToggleForm model.expenseFormWidget
                    in
                        ( { model | expenseFormWidget = updatedModel }, Cmd.map ExpenseFormsMsg cmd )

        -- ( Debug.log "add expense" model, Cmd.none )
        ExpensesMsg subMsg ->
            case subMsg of
                Expenses.Messages.Edit expense ->
                    let
                        form =
                            expense2form expense

                        expenseFormWidget =
                            model.expenseFormWidget

                        newModel =
                            { model
                                | expenseFormWidget =
                                    { expenseFormWidget
                                        | form = form
                                        , show = True
                                    }
                            }
                    in
                        ( newModel, Cmd.none )

        -- _ ->
        --     let
        --         ( updatedExpenses, cmd ) =
        --             Expenses.Update.update subMsg model.expenses
        --     in
        --         ( { model | expenses = updatedExpenses }, Cmd.map ExpensesMsg cmd )
        ExpenseFormsMsg subMsg ->
            case subMsg of
                ExpenseForms.Messages.Save formWidget ->
                    let
                        ( updatedExpenseForm, cmd ) =
                            ExpenseForms.Update.update subMsg model.expenseFormWidget

                        expenses =
                            model.expenses

                        newExpense =
                            form2expense formWidget.form
                    in
                        ( { model
                            | expenses = updateExpenses expenses newExpense
                            , expenseFormWidget = updatedExpenseForm
                          }
                        , Cmd.map ExpenseFormsMsg cmd
                        )

                _ ->
                    let
                        ( updatedExpenseForm, cmd ) =
                            ExpenseForms.Update.update subMsg model.expenseFormWidget
                    in
                        ( { model | expenseFormWidget = updatedExpenseForm }, Cmd.map ExpenseFormsMsg cmd )
