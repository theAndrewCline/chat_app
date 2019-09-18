port module Main exposing (..)

import Browser exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
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
    , textInput : String
    , errorMsg : Maybe Decode.Error
    , message : String
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
              , textInput = ""
              , errorMsg = Nothing
              , message = ""
              }
            , Cmd.none
            )

        Err err ->
            ( { history = []
              , textInput = ""
              , errorMsg = Just err
              , message = ""
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
    | UpdateTextInput String
    | SendMessage


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateHistory newHistory ->
            ( { model | history = newHistory }, Cmd.none )

        UpdateTextInput string ->
            ( { model | textInput = string }, Cmd.none )

        SendMessage ->
            ( { model | message = model.textInput, textInput = "" }, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ viewHistory model.history
        , div [ class "input-container" ]
            [ input
                [ id "messageInput"
                , onInput UpdateTextInput
                , onEnter SendMessage
                ]
                [ text model.textInput ]

            -- , button [ id "sendMessage"] [ text "send" ]
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


onEnter : Msg -> Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Decode.succeed msg

            else
                Decode.fail "not ENTER"
    in
    on "keydown" (Decode.andThen isEnter keyCode)
