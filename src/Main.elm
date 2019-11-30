port module Main exposing (..)

import Browser
import Browser.Navigation
import Css exposing (..)
import Css.Transitions exposing (transition, linear, easeInOut)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (..)
import Html.Styled.Events exposing (..)
import Http exposing (..)
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
  , showSettings: Bool
  }


type alias State =
  { lighting: String
  }


type Lighting = Dark | Light


type alias Colors =
  { background: Color
  , menuBackground: Color
  , text: Color
  , border: Color
  , buttonBackground: Color
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
  , showSettings = False
  }


modelFromState : State -> Model
modelFromState state =
  let
    lighting = if state.lighting == "dark" then Dark else Light
  in
    defaultModel lighting


stateFromModel : Model -> State
stateFromModel model =
  { lighting = if model.lighting == Dark then "dark" else "light"
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
  { background = hex "000"
  , menuBackground = hex "111"
  , text = hex "CCC"
  , border = hex "333"
  , buttonBackground = hex "444"
  }


lightColors : Colors
lightColors =
  { background = hex "FFF"
  , menuBackground = hex "EEE"
  , text = hex "000"
  , border = hex "CCC"
  , buttonBackground = hex "CCC"
  }

---- UPDATE ----


type Msg
  = ChangeLighting Bool
  | Update
  | ToggleSettings Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    ChangeLighting checked ->
      ( { model | lighting = if checked then Light else Dark }, Cmd.none )
    Update ->
      ( model, Browser.Navigation.reloadAndSkipCache )
    ToggleSettings checked  ->
      ( { model | showSettings = checked }, Cmd.none )



---- VIEW ----


view : Model -> Html Msg
view model =
  let
    colors = colorValues model.lighting
  in
    div
      [ css
        [ backgroundColor colors.background
        , color colors.text
        , padding (px 15)
        , Css.height (pct 100)
        ]
      ]
      [ header
      , if model.showSettings then
          shield (ToggleSettings False) False
        else
          text ""
      , viewSettings model
      , footer model
      ]


header : Html Msg
header =
  div
    [ css
      [ borderBottom3 (px 1) solid (hex "e6bc2f")
      , paddingTop (px 22)
      , paddingBottom (px 20)
      , margin zero
      , marginBottom (px 25)
      ]
    ]
    [ img
      [ src "logo-pokemon.png"
      , css [ display block, margin2 zero auto ]
      ] []
    ]


footer : Model -> Html Msg
footer model =
  let colors = colorValues model.lighting in
  div
    [ css
      [ displayFlex
      , flexDirection rowReverse
      , position absolute
      , bottom zero
      , right (px 15)
      , left (px 15)
      , padding2 (px 15) zero
      , backgroundColor colors.background
      ]
    ]
    [ footerBorder model
    , viewSettingsToggle model
    ]


footerBorder : Model -> Html Msg
footerBorder model =
  div
    [ css
      [ Css.height (px 1)
      , position absolute
      , right zero
      , left zero
      , top (px -1)
      , borderTop3 (px 1) solid (hex "e6bc2f")
      , transition
          [ Css.Transitions.transform3 300 0 easeInOut
          ]
      , if model.showSettings then
          batch [ transform (translateY (px 10)) ]
        else
          batch [ ]       
      ]
    ]
    []


viewSettingsToggle : Model -> Html Msg
viewSettingsToggle model =
  labeledCheckbox
    model
    "settings-toggle"
    "Settings"
    [ ]
    [ ]
    model.showSettings
    ToggleSettings


viewSettings : Model -> Html Msg
viewSettings model =
  let colors = colorValues model.lighting in
  div
    [ css (shownSettings model)
    ]
    [ labeledCheckbox
        model
        "lighting"
        (if model.lighting == Light then "Dark mode" else "Light mode")
        [  ]
        [  ]
        (model.lighting == Light)
        ChangeLighting
    , hr [ css
           [ display block
           , Css.height (px 1)
           , border zero
           , borderTop3 (px 1) solid colors.border
           , margin2 (px 10) zero
           , padding zero
           ]
          ] []
    , button
      [ css [ Css.width (pct 100), batch (buttonStyle model) ]
      , onClick Update
      ]
      [ text "Reload" ]
    ]


shield : Msg -> Bool -> Html Msg
shield msg dim =
  div 
    [ css
      [ position absolute
      , left (px 0)
      , top (px 0)
      , right (px 0)
      , bottom (px 0)
      , if dim then
          batch
          [ backgroundColor (hex "#111")
          , opacity (num 0.2)
          ]
        else
          batch []
      ]
    , onClick msg
    ]
    []


shownSettings : Model -> List Style
shownSettings model =
  [ padding (px 10)
  , Css.width (px 150)
  , textAlign left
  , batch (menuBorder model)
  , position absolute
  , right (px 15)
  , bottom (px 51)
  , borderColor (hex "e6bc2f")
  , transition
      [ Css.Transitions.transform3 400 0 easeInOut
      , Css.Transitions.opacity3 300 100 linear
      ]
  , if model.showSettings then
      batch [ transform (translateY zero), opacity (Css.int 1) ]
    else
      batch [ transform (translateY (pct 100)), opacity zero ]
  ]


labeledCheckbox : Model -> String -> String -> List Style -> List Style -> Bool -> (Bool -> Msg) -> Html Msg
labeledCheckbox model elemid elemlabel elemCss labelCss isChecked msg =
  let
    colors = colorValues model.lighting
  in
    div [] 
      [ input
        [ type_ "checkbox"
        , id elemid
        , css (batch [ display none ] :: elemCss)
        , Html.Styled.Attributes.checked isChecked
        , onCheck msg
        ] []
      , label 
        [ css (batch [ color colors.text ] :: labelCss)
        , for elemid
        ]
        [ text elemlabel ]
      ]


menuBorder : Model -> List Style
menuBorder model =
  let colors = colorValues model.lighting in
  [ border3 (px 1) solid colors.border
  , borderRadius (px 20)
  ]


buttonStyle : Model -> List Style
buttonStyle model =
  let colors = colorValues model.lighting in
  [ backgroundColor colors.buttonBackground
  , padding2 (px 6) (px 20)
  , borderRadius (px 10)
  ]


