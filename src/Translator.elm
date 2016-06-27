module Translator exposing (..)

import ExpensesListWidget.Translator exposing (Translator)
import Messages exposing (Msg(..))


expensesListWidgetTranslator : Translator Msg
expensesListWidgetTranslator =
    ExpensesListWidget.Translator.translator
        { onInternalMessage = ExpensesListWidgetMsg
        , onEdit = Edit
        }
