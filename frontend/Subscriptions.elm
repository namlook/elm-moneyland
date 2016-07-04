module Subscriptions exposing (..)

import Models exposing (Model)
import Messages exposing (Msg(..))
import Components.FlashMessages as FlashMessages


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.map FlashMessagesMsg (FlashMessages.subscriptions model.flashMessages)
