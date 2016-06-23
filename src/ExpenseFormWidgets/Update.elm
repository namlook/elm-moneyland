module ExpenseFormWidgets.Update exposing (..)

import ExpenseFormWidgets.Models exposing (ExpenseFormWidget, expense2form)
import ExpenseFormWidgets.Messages exposing (Msg(..))


update : Msg -> ExpenseFormWidget -> ( ExpenseFormWidget, Cmd Msg )
update msg formWidget =
    let
        form =
            formWidget.form
    in
        case msg of
            TitleChange title ->
                ( { formWidget | form = { form | title = title } }, Cmd.none )

            DateChange date ->
                ( { formWidget | form = { form | date = date } }, Cmd.none )

            AmountChange amount ->
                ( { formWidget | form = { form | amount = amount } }, Cmd.none )

            ForChange for ->
                ( { formWidget | form = { form | for = for } }, Cmd.none )

            PaidByChange paidBy ->
                ( { formWidget | form = { form | paidBy = paidBy } }, Cmd.none )

            CategoriesChange categories ->
                ( { formWidget | form = { form | categories = categories } }, Cmd.none )

            Save form ->
                ( { formWidget | form = ExpenseFormWidgets.Models.initExpenseForm }, Cmd.none )

            ToggleForm ->
                ( { formWidget | show = not formWidget.show }, Cmd.none )

            UpdateForm expense ->
                ( { formWidget | form = expense2form expense }, Cmd.none )

            Cancel ->
                ( { formWidget
                    | form = ExpenseFormWidgets.Models.initExpenseForm
                    , show = False
                  }
                , Cmd.none
                )
