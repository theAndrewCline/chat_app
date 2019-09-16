port module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Json.Encode as Encode
import Time


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


port history : (Encode.Value -> msg) -> Sub msg



-- MODEL


type alias Model =
    { history : List Int
    , errorMsg : Maybe Decode.Error
    }



-- type alias Message =
--     { author : String
--     , content : String
--     , timestamp : Time.Posix
--     }
--INIT


historyDecoder : Decode.Decoder (List Int)
historyDecoder =
    Decode.list Decode.int


init : Encode.Value -> ( Model, Cmd Msg )
init historyFlag =
    case Decode.decodeValue historyDecoder historyFlag of
        Ok initHistory ->
            ( { history = initHistory
              , errorMsg = Nothing
              }
            , Cmd.none
            )

        Err err ->
            ( { history = [ 5, 6, 7 ]
              , errorMsg = Just err
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


updateHistory : Decode.Value -> Msg
updateHistory updatedHistory =
    case Decode.decodeValue historyDecoder updatedHistory of
        Ok newHistory ->
            UpdateHistory newHistory

        Err err ->
            NoOp


subscriptions : Model -> Sub Msg
subscriptions model =
    history updateHistory



-- UPDATE


type Msg
    = NoOp
    | UpdateHistory (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateHistory newHistory ->
            ( { model | history = newHistory }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ ul [ id "messageHistory" ]
            [ li [] [ text "hello" ]
            ]
        , div [ class "input-container" ]
            [ input [ id "messageInput" ] []
            , button [ id "sendMessage" ] [ text "send" ]
            ]
        ]
