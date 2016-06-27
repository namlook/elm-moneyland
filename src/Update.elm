module Update exposing (..)

import Models exposing (Model)
import Messages exposing (Msg(..))


-- import ExpensesListWidget.Messages

import Translator exposing (expensesListWidgetTranslator, expenseFormWidgetTranslator)
import ExpensesListWidget.Update
import ExpenseFormWidgets.Update
import ExpenseFormWidgets.Messages
import ExpenseFormWidgets.Models exposing (ExpenseForm, expense2form)
import Types exposing (Expense)
import Components.NavBar
import String
import Date


toExpenseId : String -> Maybe Int
toExpenseId id =
    Result.toMaybe <| String.toInt id


form2expense : ExpenseForm -> Expense
form2expense form =
    { id = Just <| Result.withDefault -1 <| String.toInt form.id
    , title = form.title
    , date = Date.fromString form.date |> Result.withDefault (Date.fromTime 0)
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
                            ExpenseFormWidgets.Update.update ExpenseFormWidgets.Messages.ToggleForm model.expenseFormWidget
                    in
                        ( { model | expenseFormWidget = updatedModel }, Cmd.map expenseFormWidgetTranslator cmd )

        ExpensesListWidgetMsg internal ->
            let
                ( widget, cmd ) =
                    ExpensesListWidget.Update.update internal model.expensesListWidget
            in
                ( { model | expensesListWidget = widget }, Cmd.map expensesListWidgetTranslator cmd )

        Edit expense ->
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
                                , display = ExpenseFormWidgets.Models.Opened ExpenseFormWidgets.Models.Edit
                                , show = True
                            }
                    }
            in
                ( newModel, Cmd.none )

        ExpenseFormWidgetMsg internal ->
            let
                ( widget, cmd ) =
                    ExpenseFormWidgets.Update.update internal model.expenseFormWidget
            in
                ( { model | expenseFormWidget = widget }, Cmd.map expenseFormWidgetTranslator cmd )

        Save formWidget ->
            let
                expensesListWidget =
                    model.expensesListWidget

                newExpense =
                    form2expense formWidget.form
            in
                ( { model
                    | expensesListWidget =
                        { expensesListWidget
                            | expenses = updateExpenses expensesListWidget.expenses newExpense
                        }
                  }
                , Cmd.none
                )
