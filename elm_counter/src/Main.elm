port module Main exposing (Model, Msg(..), update, view)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Json.Decode as D
import Json.Encode as E



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { count : Int }



-- MSG


type Msg
    = Increment
    | Decrement
    | SetValue D.Value
    | RequestValue



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { count = 0 }
    , Cmd.none
    )



-- UPDATE


updateCount model newValue =
    ( { model | count = newValue }
    , portSendValue (E.int newValue)
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            updateCount model (model.count + 1)

        Decrement ->
            updateCount model (model.count - 1)

        SetValue value ->
            case D.decodeValue D.int value of
                Ok ivalue ->
                    ( { model | count = ivalue }
                    , Cmd.none
                    )

                Err error ->
                    ( model, Cmd.none )

        RequestValue ->
            ( model, portSendValue (E.int model.count) )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick Increment ] [ text "+1" ]
        , div [] [ text <| String.fromInt model.count ]
        , button [ onClick Decrement ] [ text "-1" ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ portSetValue SetValue
        , requestCountValue (always RequestValue)
        ]



-- PORTS


port requestCountValue : (() -> msg) -> Sub msg


port portSendValue : E.Value -> Cmd msg


port portSetValue : (D.Value -> msg) -> Sub msg
