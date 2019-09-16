port module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Http exposing (Error(..))
import Json.Decode as Decode
import Time


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { history : List Message
    , errorMsg : Maybe Decode.Error
    }


type alias Message =
    { author : String
    , text : String
    , timestamp : Int
    }



-- JSON DECODERS


historyDecoder : Decode.Decoder (List Message)
historyDecoder =
    Decode.list messageDecoder


messageDecoder : Decode.Decoder Message
messageDecoder =
    Decode.map3 Message
        (Decode.field "author" Decode.string)
        (Decode.field "text" Decode.string)
        (Decode.field "timestamp" Decode.int)



--INIT


init : Decode.Value -> ( Model, Cmd Msg )
init historyFlag =
    case Decode.decodeValue historyDecoder historyFlag of
        Ok initHistory ->
            ( { history = initHistory
              , errorMsg = Nothing
              }
            , Cmd.none
            )

        Err err ->
            ( { history = []
              , errorMsg = Just err
              }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    history updateHistory


port history : (Decode.Value -> msg) -> Sub msg


updateHistory : Decode.Value -> Msg
updateHistory updatedHistory =
    case Decode.decodeValue historyDecoder updatedHistory of
        Ok newHistory ->
            UpdateHistory newHistory

        Err err ->
            NoOp



-- UPDATE


type Msg
    = NoOp
    | UpdateHistory (List Message)


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
        [ viewHistory model.history
        , div [ class "input-container" ]
            [ input [ id "messageInput" ] []
            , button [ id "sendMessage" ] [ text "send" ]
            ]
        ]


viewHistory : List Message -> Html Msg
viewHistory historyModel =
    ul [ id "messageHistory" ]
        (List.map
            (\message ->
                viewMessage message
            )
            historyModel
        )


viewMessage : Message -> Html Msg
viewMessage message =
    li []
        [ div [ class "line" ] []
        , div []
            [ span [ class "author" ] [ text message.author ]
            , span [ class "timestamp" ] [ text (String.fromInt message.timestamp) ]
            ]
        , div [] [ text message.text ]
        ]
