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
  , query: String
  , searchStatus: SearchStatus
  , searchResults: Maybe TypeResult
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


type SearchStatus
  = Loading
  | Failure
  | Success


type alias TypeResult =
  { typeInfo: TypeInfo
  , relationships: TypeRelationships
  }


type alias TypeInfo =
  { id: String
  , name: String    
  }


type alias TypeRelationships =
  { effectiveAgainst: List TypeInfo
  , weakAgainst: List TypeInfo
  , ineffectiveAgainst: List TypeInfo
  , resistantTo: List TypeInfo
  , counters: List TypeInfo
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
  , query = ""
  , searchStatus = Success
  , searchResults = Nothing
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
  = UpdateQuery String
  | Search
  | SearchResult (Result Http.Error TypeApiResult)
  | ChangeLighting Bool
  | Update
  | ToggleSettings Bool


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateQuery query ->
      ( { model | query = query }, Cmd.none )
    Search ->
      ( { model | searchStatus = Loading }
      , searchType model.query
      )
    SearchResult result ->
      case result of
        Ok typeResult ->
          ( { model
            | searchStatus = Success
            , searchResults = Just (mapApiResult typeResult)
            }
          , Cmd.none
          )
        Err _ ->
          ( { model | searchStatus = Failure }, Cmd.none )
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
      , searchView model
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


searchView : Model -> Html Msg
searchView model =
  div []
    [ searchBox model
    , searchResults model
    ]


searchBox : Model -> Html Msg
searchBox model =
  let
    colors = colorValues model.lighting
  in
    Html.Styled.form
      [ css
        [ Css.width (pct 100)
        , color colors.text
        , displayFlex
        , batch (menuBorder model)
        , padding (px 3)
        , boxSizing borderBox
        ]
      , onSubmit Search
      ]
      [ input
          [ css
            [ Css.width (pct 100)
            , paddingLeft (px 8)
            , border zero
            ]
          , placeholder "Search for a Pokemon type"
          , Html.Styled.Attributes.value model.query
          , onInput UpdateQuery
          , Html.Styled.Attributes.required True
          ]
          []
      , button
        [ type_ "submit"
        , css
          [ batch (buttonStyle model)
          , borderRadius (px 17)
          ]
        ]
        [ text "Search" ]
      ]


searchResults : Model -> Html Msg
searchResults model =
  case model.searchStatus of
    Loading -> loadingSearchResults model
    Failure -> failureSearchResults
    Success -> successSearchResults model


loadingSearchResults : Model -> Html Msg
loadingSearchResults model =
  div [] [ text ("Loading " ++ model.query) ]


failureSearchResults : Html Msg
failureSearchResults =
  div [] [ text "Could not load results. Please try again later." ]


successSearchResults : Model -> Html Msg
successSearchResults model =
  case model.searchResults of
    Nothing ->
      text ""
    Just results ->
      div
        [ css [ marginTop (px 20) ] ]
        [ resultsTable results.relationships
        ]


resultsTable : TypeRelationships -> Html Msg
resultsTable relationships =
  Html.Styled.table
    [ css
      [ borderCollapse collapse
      , tableLayout fixed
      , color (hex "111")
      ]
    ]
    [ tr [ css [ backgroundColor (hex "69c423") ] ]
      [ td [ css tableDataStyle ] [ text "Effective against" ]
      , displayResults relationships.effectiveAgainst
      ]
    , tr [ css [ backgroundColor (hex "f9ed63") ] ]
      [ td [ css tableDataStyle ] [ text "Weak against" ]
      , displayResults relationships.weakAgainst
      ]
    , tr [ css [ backgroundColor (hex "f78360") ] ]
      [ td [ css tableDataStyle ] [ text "Ineffective against" ]
      , displayResults relationships.ineffectiveAgainst
      ]
    , tr [ css [ backgroundColor (hex "20c0f9") ] ]
      [ td [ css tableDataStyle ] [ text "Resistant to" ]
      , displayResults relationships.resistantTo
      ]
    , tr [ css [ backgroundColor (hex "ffa500") ] ]
      [ td [ css tableDataStyle ] [ text "Counters" ]
      , displayResults relationships.counters
      ]
    ]


tableDataStyle : List Style
tableDataStyle =
  [ padding (px 20)
  , textAlign center
  ]


displayResults : List TypeInfo -> Html Msg
displayResults types =
  td [ css tableDataStyle ]
    [ text (
      if List.isEmpty types then
        "--"
      else
        String.join ", " (List.map (\t -> t.name) types)
      )
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
          [ Css.Transitions.left3 300 0 linear
          , Css.Transitions.right3 300 0 linear
          ]
      , if model.showSettings then
          batch
            [ left (calc (pct 100) minus (px 152))
            , right (px 20)
            ]
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
  , transition [ Css.Transitions.transform3 400 0 easeInOut ]
  , if model.showSettings then
      batch [ transform (translateY zero) ]
    else
      batch [ transform (translateY (pct 100)) ]
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



-- HTTP


type alias TypeApiResult =
  { id: String
  , name: String
  , relationships: TypeRelationship
  }


type alias TypeRelationship =
  { resistantTo: List TypeApiShorthand
  , counters: List TypeApiShorthand
  , effectiveAgainst: List TypeApiShorthand
  , weakAgainst: List TypeApiShorthand
  , ineffectiveAgainst: List TypeApiShorthand
  }


type alias TypeApiShorthand =
  { id: String
  , name: String
  }


mapApiResult : TypeApiResult -> TypeResult
mapApiResult apiResult =
  { typeInfo = { id = apiResult.id, name = apiResult.name }
  , relationships =
    { effectiveAgainst = apiResult.relationships.effectiveAgainst
    , weakAgainst = apiResult.relationships.weakAgainst
    , ineffectiveAgainst = apiResult.relationships.ineffectiveAgainst
    , resistantTo = apiResult.relationships.resistantTo
    , counters = apiResult.relationships.counters
    }
  }


normalizeQuery : String -> String
normalizeQuery q =
  String.toLower (String.trim q)


searchType : String -> Cmd Msg
searchType t =
  Http.get
    { url = "https://pokemon-type-api.herokuapp.com/type/" ++ normalizeQuery t
    , expect = Http.expectJson SearchResult typeDecoder
    }


typeDecoder : Decoder TypeApiResult
typeDecoder =
  Json.Decode.map3 TypeApiResult
    (field "type" string)
    (field "name" string)
    (field "relationships" typeRelationshipDecoder)


typeRelationshipDecoder : Decoder TypeRelationship
typeRelationshipDecoder =
  Json.Decode.map5 TypeRelationship
    (field "resistantTo" (Json.Decode.list typeShorthandDecoder))
    (field "counters" (Json.Decode.list typeShorthandDecoder))
    (field "effectiveAgainst" (Json.Decode.list typeShorthandDecoder))
    (field "weakAgainst" (Json.Decode.list typeShorthandDecoder))
    (field "ineffectiveAgainst" (Json.Decode.list typeShorthandDecoder))


typeShorthandDecoder : Decoder TypeApiShorthand
typeShorthandDecoder =
  Json.Decode.map2 TypeApiShorthand
    (field "type" string)
    (field "name" string)


