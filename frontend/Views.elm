module Views exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)
import Html.App as App
import Models exposing (Model)
import Messages exposing (Msg(..))
import ExpensesListWidget.List
import ExpenseFormWidgets.Form
import Components.NavBar as NavBar
import Components.FlashMessages as FlashMessages
import Components.Auth as Auth exposing (Authentification(Anonymous, LoggedUser))
import Translator exposing (expensesListWidgetTranslator, expenseFormWidgetTranslator, authTranslator)


content : Model -> Html Msg
content model =
    case model.auth.user of
        Anonymous ->
            App.map authTranslator (Auth.view model.auth)

        LoggedUser user ->
            div []
                [ App.map expenseFormWidgetTranslator (ExpenseFormWidgets.Form.view model.expenseFormWidget)
                , App.map expensesListWidgetTranslator (ExpensesListWidget.List.view model.expensesListWidget)
                ]


view : Model -> Html Msg
view model =
    div [ class "mainapp" ]
        [ App.map NavBarMsg (NavBar.view model.auth.user)
        , App.map FlashMessagesMsg (FlashMessages.view model.flashMessages)
        , content model
        ]
