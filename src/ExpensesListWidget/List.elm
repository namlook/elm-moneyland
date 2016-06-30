module ExpensesListWidget.List exposing (..)

import Html exposing (Html, div, text, table, thead, tbody, tr, td, th, input, form, a, i, label)
import Html.Attributes exposing (class, type', classList)
import Html.Events exposing (onClick)
import Types exposing (Expense)
import ExpensesListWidget.Models exposing (ExpensesListWidget, Sorting(..), SortOrder(..))
import ExpensesListWidget.Messages exposing (Msg(..), OutMsg(..), InternalMsg(..))
import Date exposing (Date)
import String


view : ExpensesListWidget -> Html Msg
view widget =
    div []
        [ table [ class "ui celled sortable striped padded table" ]
            [ viewHeader widget [ "title", "date", "amount", "for", "paid by", "categories" ]
            , tbody [] (List.map viewRow widget.expenses)
            ]
        ]


sortingClass : String -> ExpensesListWidget -> String
sortingClass fieldname widget =
    case widget.sortBy of
        SortingField sortingField ->
            if sortingField == fieldname then
                case widget.order of
                    Asc ->
                        "sorted ascending"

                    Desc ->
                        "sorted descending"
            else
                ""

        NoSorting ->
            ""


viewHeader : ExpensesListWidget -> List String -> Html Msg
viewHeader widget fields =
    thead []
        ([ th [] [] ]
            ++ (List.map
                    (\field ->
                        th
                            [ onClick (ForSelf (ToggleSorting field))
                            , class (sortingClass field widget)
                            ]
                            [ text field ]
                    )
                    fields
               )
            ++ [ th [] [] ]
        )


beautifyDate : Date -> String
beautifyDate date =
    -- let
    --     date =
    --         Result.withDefault (Date.fromTime 0) (Date.fromString datestring)
    -- in
    (toString <| Date.day date)
        ++ "/"
        ++ (toString <| Date.month date)
        ++ "/"
        ++ (toString <| Date.year date)


editIcon : Expense -> Html Msg
editIcon expense =
    a [ class "ui labeled button", onClick (ForParent (Edit expense)) ] [ i [ class "ui edit icon" ] [] ]


deleteIcon : Expense -> Html Msg
deleteIcon expense =
    a [ class "ui labeled button", onClick (ForSelf (Delete expense)) ] [ i [ class "ui remove red icon" ] [] ]


viewRow : Expense -> Html Msg
viewRow expense =
    tr []
        [ td [] [ editIcon expense ]
        , td [] [ text expense.title ]
        , td [] [ text <| beautifyDate expense.date ]
        , td [] [ text <| toString expense.amount ]
        , td [] [ text <| String.join "," expense.for ]
        , td [] [ text expense.paidBy ]
        , td [] [ text <| String.join "," expense.categories ]
        , td [] [ deleteIcon expense ]
        ]
