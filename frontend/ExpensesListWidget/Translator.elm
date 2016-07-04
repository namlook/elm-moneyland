module ExpensesListWidget.Translator exposing (..)

import ExpensesListWidget.Messages exposing (Msg(..), InternalMsg(..), OutMsg(..))
import Types exposing (Expense)
import Task
import Http


type alias TranslationDictionary parentMsg =
    { onInternalMessage : InternalMsg -> parentMsg
    , onEdit : Expense -> parentMsg
    , onRemoteError : Http.Error -> parentMsg
    }


type alias Translator parentMsg =
    Msg -> parentMsg


translator : TranslationDictionary parentMsg -> Translator parentMsg
translator { onInternalMessage, onEdit, onRemoteError } msg =
    case msg of
        ForSelf internal ->
            onInternalMessage internal

        ForParent (Edit expense) ->
            onEdit expense

        ForParent (RemoteError error) ->
            onRemoteError error


never : Never -> a
never n =
    never n


generateParentMsg : OutMsg -> Cmd Msg
generateParentMsg outMsg =
    Task.perform never ForParent (Task.succeed outMsg)
