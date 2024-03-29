module Translator exposing (..)

import Messages exposing (Msg(..))
import ExpensesListWidget.Translator
import ExpenseFormWidgets.Translator
import Components.Auth as Auth


expensesListWidgetTranslator : ExpensesListWidget.Translator.Translator Msg
expensesListWidgetTranslator =
    ExpensesListWidget.Translator.translator
        { onInternalMessage = ExpensesListWidgetMsg
        , onEdit = Edit
        , onRemoteError = RemoteError
        }


expenseFormWidgetTranslator : ExpenseFormWidgets.Translator.Translator Msg
expenseFormWidgetTranslator =
    ExpenseFormWidgets.Translator.translator
        { onInternalMessage = ExpenseFormWidgetMsg
        , onSave = Save
        }


authTranslator : Auth.Translator Msg
authTranslator =
    Auth.translator
        { onInternalMessage = AuthMsg
        , onLoginSucceed = LoginSucceed
        , onLoginFailed = RemoteError
        }
