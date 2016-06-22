module ExpenseForms.Update exposing (..)

import ExpenseForms.Models exposing (ExpenseForm)
import ExpenseForms.Messages exposing (Msg(..))


update : Msg -> ExpenseForm -> ( ExpenseForm, Cmd Msg )
update msg form =
    case msg of
        TitleChange title ->
            ( { form | title = title }, Cmd.none )

        DateChange date ->
            ( { form | date = date }, Cmd.none )

        AmountChange amount ->
            ( { form | amount = amount }, Cmd.none )

        ForChange for ->
            ( { form | for = for }, Cmd.none )

        PaidByChange paidBy ->
            ( { form | paidBy = paidBy }, Cmd.none )

        CategoriesChange categories ->
            ( { form | categories = categories }, Cmd.none )

        Save form ->
            ( ExpenseForms.Models.initModel, Cmd.none )
