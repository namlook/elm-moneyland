module ExpensesListWidget.Translator exposing (..)

import ExpensesListWidget.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import Types exposing (Expense)


type alias TranslationDictionary parentMsg =
    { onInternalMessage : InternalMsg -> parentMsg
    , onEdit : Expense -> parentMsg
    }


type alias Translator parentMsg =
    Msg -> parentMsg


translator : TranslationDictionary parentMsg -> Translator parentMsg
translator { onInternalMessage, onEdit } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal

        ForParent (Edit expense) ->
            onEdit expense
