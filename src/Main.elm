port module Main exposing (..)

import Browser
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Json.Decode exposing (..)



---- PROGRAM ----


main : Program Json.Decode.Value Model Msg
main =
  Browser.document
    { view = \model -> { title = "Pokemon", body = [ model |> view |> toUnstyled ] }
    , init = init
    , update = updateWithStorage
    , subscriptions = always Sub.none
    }


port setStorage : State -> Cmd msg


{-| We want to `setStorage` on every update. This function adds the setStorage
command for every step of the update function.
-}
updateWithStorage : Msg -> Model -> ( Model, Cmd Msg )
updateWithStorage msg model =
    let
        ( newModel, cmds ) =
            update msg model
    in
        ( newModel
        , Cmd.batch [ setStorage (stateFromModel newModel), cmds ]
        )


---- MODEL ----


type alias Model =
  { lighting: Lighting
  }


type alias State =
  { lighting: String
  }


type Lighting = Dark | Light


type alias Colors =
  { background: Color
  , menuBackground: Color
  , text: Color
  }


init : Json.Decode.Value -> ( Model, Cmd Msg )
init state =
  let
    decodedState = Json.Decode.decodeValue decodeState state
    finalState = case decodedState of
      Ok s -> s
      Err _ -> defaultState
  in
    ( modelFromState finalState, Cmd.none )


defaultModel : Lighting -> Model
defaultModel lighting =
  { lighting = lighting
  }


modelFromState : State -> Model
modelFromState state =
  let
    lighting = (if state.lighting == "dark" then Dark else Light)
  in
    defaultModel lighting


stateFromModel : Model -> State
stateFromModel model =
  { lighting = (if model.lighting == Dark then "dark" else "light")
  }


decodeState : Decoder State
decodeState =
  Json.Decode.map State (field "lighting" string)


defaultState : State
defaultState =
  { lighting = "light"
  }


colorValues : Lighting -> Colors
colorValues lighting =
  if lighting == Dark then darkColors else lightColors


darkColors : Colors
darkColors =
  { background = (hex "000")
  , menuBackground = (hex "333")
  , text = (hex "CCC")
  }


lightColors : Colors
lightColors =
  { background = (hex "FFF")
  , menuBackground = (hex "EEE")
  , text = (hex "000")
  }

---- UPDATE ----


type Msg
  = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  ( model, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
  let
    colors = colorValues model.lighting
  in
    div
      [ css [ backgroundColor colors.background ] ]
      [ h1 [] [ text "Your Elm App is different!" ]
      ]
