module Update exposing (..)

import String
import Date
import Html exposing (text)
import Types exposing (Expense)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Translator exposing (expensesListWidgetTranslator, expenseFormWidgetTranslator, authTranslator)
import ExpensesListWidget.Update
import ExpensesListWidget.Messages
import ExpensesListWidget.Commandes
import ExpenseFormWidgets.Update
import ExpenseFormWidgets.Messages
import ExpenseFormWidgets.Models exposing (ExpenseForm, expense2form)
import Components.NavBar
import Components.FlashMessages as FlashMessages
import Components.Auth as Auth exposing (Authentification(LoggedUser))


toExpenseId : String -> Maybe String
toExpenseId id =
    case id of
        "" ->
            Nothing

        _ ->
            Just id


form2expense : ExpenseForm -> Expense
form2expense form =
    { id = toExpenseId form.id
    , title = form.title
    , date = Date.fromString form.date |> Result.withDefault (Date.fromTime 0)
    , amount = Result.withDefault 0 <| String.toFloat form.amount
    , for = List.sort <| String.split "," form.for
    , paidBy = form.paidBy
    , categories = List.sort <| String.split "," form.categories
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



-- -- expensesListWidgetComponent =
-- --     { update = ...
-- --     , model = ...
-- --     , translator = ...
-- --     }
-- -- updateComponent : ComponentInfos -> (a -> b) -> Model -> Msg
-- -- updateComponent expensesListWidgetComponent .expensesListWidget model msg
--
--
-- expensesListWidgetComponent =
--     { update = ExpensesListWidget.Update.update
--     , model = .expensesListWidget
--     , translator = expensesListWidgetTranslator
--     }
--
--
-- expenseFormWidgetComponent =
--     { update = ExpenseFormWidgets.Update.update
--     , model = .expenseFormWidget
--     , translator = expenseFormWidgetTranslator
--     }
--
--
-- updateComponent componentInfos setter model msg =
--     let
--         ( updatedModel, cmd ) =
--             componentInfos.update msg (componentInfos.model model)
--     in
--         ( setter model updatedModel, Cmd.map componentInfos.translator cmd )
--
--
-- updateExpensesListWidgetComponent =
--     updateComponent expensesListWidgetComponent (\m u -> { m | expensesListWidget = u })
--
--
-- updateExpenseFormWidgetComponent =
--     updateComponent expenseFormWidgetComponent (\m u -> { m | expenseFormWidget = u })


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
                    ExpensesListWidget.Update.update model.auth.user internal model.expensesListWidget
            in
                ( { model | expensesListWidget = widget }, Cmd.map expensesListWidgetTranslator cmd )

        Edit expense ->
            let
                expenseFormWidget =
                    model.expenseFormWidget

                newModel =
                    { model
                        | expenseFormWidget =
                            { expenseFormWidget
                                | form = expense2form expense
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
                newExpense =
                    form2expense formWidget.form

                ( widget, cmd ) =
                    ExpensesListWidget.Update.update model.auth.user (ExpensesListWidget.Messages.Add newExpense) model.expensesListWidget
            in
                ( { model | expensesListWidget = widget }, Cmd.map expensesListWidgetTranslator cmd )

        RemoteError error ->
            ( { model
                | flashMessages =
                    model.flashMessages
                        ++ [ { type' = FlashMessages.Error
                             , dismissable = True
                             , icon = Just "remove"
                             , title = "An error occured on the server"
                             , shownFor = Nothing
                             , body = Just (text <| toString error)
                             }
                           ]
              }
            , Cmd.none
            )

        FlashMessagesMsg internal ->
            let
                ( queue, cmd ) =
                    FlashMessages.update internal model.flashMessages
            in
                ( { model | flashMessages = queue }, Cmd.map FlashMessagesMsg cmd )

        AuthMsg internal ->
            let
                ( widget, cmd ) =
                    Auth.update internal model.auth
            in
                ( { model | auth = widget }, Cmd.map authTranslator cmd )

        LoginSucceed credentials ->
            let
                auth =
                    model.auth

                user =
                    LoggedUser credentials
            in
                ( { model | auth = { auth | user = user } }
                , ExpensesListWidget.Commandes.fetchAllExpenses user
                    |> Cmd.map ExpensesListWidgetMsg
                )
