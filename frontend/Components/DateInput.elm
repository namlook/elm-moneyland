module Components.DateInput exposing (..)

import Html exposing (Html, div, input)
import Html.Attributes exposing (type', placeholder, class)
import Html.Events exposing (onInput)
import String


-- UNUSED


type alias DateInput =
    { day : Int
    , month : Int
    , year : Int
    }


init : DateInput
init =
    { day = 0
    , month = 0
    , year = 0
    }


type Msg
    = DayChange String
    | MonthChange String
    | YearChange String



-- date2string : DateInput -> String
-- date2string { day, month, year } =
--     (toString day) ++ "/" ++ (toString month) ++ "/" ++ (toString year)
--


view : Html Msg
view =
    div []
        [ input [ type' "number", placeholder "jour", onInput DayChange ] []
        , input [ type' "number", placeholder "mois", onInput MonthChange ] []
        , input [ type' "number", placeholder "année", onInput YearChange ] []
        ]


update : Msg -> DateInput -> ( DateInput, Cmd Msg )
update msg date =
    case msg of
        DayChange day ->
            ( { date | day = Result.withDefault -1 <| String.toInt day }, Cmd.none )

        MonthChange month ->
            ( { date | month = Result.withDefault -1 <| String.toInt month }, Cmd.none )

        YearChange year ->
            ( { date | year = Result.withDefault -1 <| String.toInt year }, Cmd.none )
