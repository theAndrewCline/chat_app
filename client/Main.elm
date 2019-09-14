module Main exposing (main)

import Browser exposing (..)
import Html exposing (..)


main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { history : List Message }


type alias Message =
    {}



--INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( { history = []
      }
    , Cmd.none
    )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = NoOp
    | UpdateHistory


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateHistory ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ span [] [ text "Hello There" ]
        ]
