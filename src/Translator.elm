module Translator exposing (..)

import Messages exposing (Msg(..))
import ExpensesListWidget.Translator
import ExpenseFormWidgets.Translator


expensesListWidgetTranslator : ExpensesListWidget.Translator.Translator Msg
expensesListWidgetTranslator =
    ExpensesListWidget.Translator.translator
        { onInternalMessage = ExpensesListWidgetMsg
        , onEdit = Edit
        }


expenseFormWidgetTranslator : ExpenseFormWidgets.Translator.Translator Msg
expenseFormWidgetTranslator =
    ExpenseFormWidgets.Translator.translator
        { onInternalMessage = ExpenseFormWidgetMsg
        , onSave = Save
        }
