module Messages exposing (..)

import ExpensesListWidget.Messages
import ExpenseFormWidgets.Messages
import Components.NavBar as NavBar
import Types exposing (Expense)
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import Components.FlashMessages as FlashMessages
import Components.Auth as Auth
import Http


type Msg
    = ExpensesListWidgetMsg ExpensesListWidget.Messages.InternalMsg
    | ExpenseFormWidgetMsg ExpenseFormWidgets.Messages.InternalMsg
    | NavBarMsg NavBar.Msg
    | FlashMessagesMsg FlashMessages.Msg
    | Edit Expense
    | Save ExpenseFormWidget
    | RemoteError Http.Error
      -- authentification
    | AuthMsg Auth.InternalMsg
    | LoginSucceed Auth.Credentials



-- | LoginFailed Http.Error
