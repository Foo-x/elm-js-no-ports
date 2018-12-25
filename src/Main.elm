module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.Lazy as Lazy
import Json.Decode as D
import Json.Encode as E
import Process
import Task



-- MAIN


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { name : String
    , output : String
    , received : String
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { name = ""
      , output = ""
      , received = ""
      }
    , Cmd.none
    )


type alias Name =
    String



-- UPDATE


type Msg
    = NoOp
    | UpdateName String
    | Receive String
    | Save


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UpdateName name ->
            ( { model | name = name }, Cmd.none )

        Receive received ->
            -- Cmd.noneだと再描画されない？
            ( { model | received = received }, Process.sleep 0 |> Task.perform (always NoOp) )

        Save ->
            ( { model | output = model.name }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- VIEW


view : Model -> Html Msg
view model =
    div
        []
        [ div
            []
            [ input
                [ onInput UpdateName
                , type_ "text"
                , value model.name
                ]
                []
            , button
                [ onClick Save ]
                [ text "Save" ]
            ]
        , span
            []
            [ text model.received ]
        , elmNode model.output
        ]


elmNode : String -> Html Msg
elmNode output =
    Html.node "elm-node"
        [ id "elm-node"
        , property "elmAttr" <| E.string output
        , on "elm-event" <| D.map Receive (D.at [ "detail" ] D.string)
        ]
        []
