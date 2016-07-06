module ExpensesListWidget.Commandes exposing (..)

import Task
import Http
import Json.Encode
import Types exposing (Expense)
import ExpensesListWidget.Messages exposing (InternalMsg(..))
import ExpensesListWidget.Models exposing (SortOrder(..), Sorting(..))
import ExpensesListWidget.Json exposing (fetchExpensesDecoder, deleteExpenseDecoder, fetchExpenseDecoder, expenseEncoder)
import Components.Auth exposing (Authentification(Anonymous, LoggedUser))


expensesEndpoint : String
expensesEndpoint =
    "/api/expenses"


auth2headers : Authentification -> List ( String, String )
auth2headers auth =
    case auth of
        Anonymous ->
            []

        LoggedUser credentials ->
            [ ( "Authorization", "Bearer " ++ credentials.token ) ]


fetchExpenses : Authentification -> String -> Cmd InternalMsg
fetchExpenses auth url =
    let
        request =
            { verb = "GET"
            , headers =
                [ ( "Content-Type", "application/json" ) ] ++ Debug.log "token" (auth2headers auth)
            , url = url
            , body = Http.empty
            }
    in
        Http.send Http.defaultSettings request
            |> Http.fromJson fetchExpensesDecoder
            |> Task.perform FetchExpensesFail FetchExpensesDone


fetchAllExpenses : Authentification -> Cmd InternalMsg
fetchAllExpenses auth =
    fetchExpenses auth expensesEndpoint


fetchExpensesBy : Authentification -> Sorting -> SortOrder -> Cmd InternalMsg
fetchExpensesBy auth sortBy sortOrder =
    let
        fieldname =
            case sortBy of
                SortingField fieldname ->
                    fieldname

                NoSorting ->
                    ""

        order =
            case sortOrder of
                Asc ->
                    "ASC"

                Desc ->
                    "DESC"

        url =
            Debug.log "url" (expensesEndpoint ++ "?_sort=" ++ fieldname ++ "&_order=" ++ order)
    in
        fetchExpenses auth url


createExpense : Authentification -> Expense -> Cmd InternalMsg
createExpense auth expense =
    let
        request =
            { verb = "POST"
            , headers = [ ( "Content-Type", "application/json" ) ] ++ auth2headers auth
            , url = expensesEndpoint
            , body = Http.string <| Json.Encode.encode 1 (expenseEncoder expense)
            }
    in
        Http.send Http.defaultSettings request
            |> Http.fromJson fetchExpenseDecoder
            |> Task.perform CreateExpenseFail CreateExpenseDone


updateExpense : Authentification -> String -> Expense -> Cmd InternalMsg
updateExpense auth expenseId expense =
    let
        request =
            { verb = "PUT"
            , headers = [ ( "Content-Type", "application/json" ) ] ++ auth2headers auth
            , url = expensesEndpoint ++ "/" ++ expenseId
            , body = Http.string <| Json.Encode.encode 1 (expenseEncoder expense)
            }
    in
        Http.send Http.defaultSettings request
            |> Http.fromJson fetchExpenseDecoder
            |> Task.perform UpdateExpenseFail UpdateExpenseDone


deleteExpense : Authentification -> String -> Cmd InternalMsg
deleteExpense auth expenseId =
    let
        request =
            { verb = "DELETE"
            , headers = auth2headers auth
            , url = expensesEndpoint ++ "/" ++ expenseId
            , body = Http.empty
            }
    in
        Http.send Http.defaultSettings request
            |> Http.fromJson deleteExpenseDecoder
            |> Task.perform DeleteExpenseFail DeleteExpenseDone
