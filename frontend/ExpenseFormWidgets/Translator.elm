module ExpenseFormWidgets.Translator exposing (..)

import ExpenseFormWidgets.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import ExpenseFormWidgets.Models exposing (ExpenseFormWidget)
import Task


type alias TranslationDictionary parentMsg =
    { onInternalMessage : InternalMsg -> parentMsg
    , onSave : ExpenseFormWidget -> parentMsg
    }


type alias Translator parentMsg =
    Msg -> parentMsg


translator : TranslationDictionary parentMsg -> Translator parentMsg
translator { onInternalMessage, onSave } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal

        ForParent (SaveExpense widget) ->
            onSave widget


never : Never -> a
never n =
    never n


generateParentMsg : OutMsg -> Cmd Msg
generateParentMsg outMsg =
    Task.perform never ForParent (Task.succeed outMsg)
