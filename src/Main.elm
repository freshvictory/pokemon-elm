port module Main exposing (..)

import Browser
import Css exposing (..)
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


type SearchStatus
  = Loading
  | Failure
  | Success


type alias TypeResult =
  { typeInfo: TypeInfo
  -- , relationships: TypeRelationships  
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
  , menuBackground = hex "333"
  , text = hex "CCC"
  }


lightColors : Colors
lightColors =
  { background = hex "FFF"
  , menuBackground = hex "EEE"
  , text = hex "000"
  }

---- UPDATE ----


type Msg
  = UpdateQuery String
  | Search
  | SearchResult (Result Http.Error TypeApiResult)


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
        ]
      ]
      [ header model
      , searchView model
      ]


header : Model -> Html Msg
header model =
  h1
    [ css
      [ textAlign center
      ]
    ]
    [ text "Search for Pokemon!" ]


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
        ]
      ]
      [ input
          [ css
              []
          , placeholder "Search for a Pokemon type"
          , Html.Styled.Attributes.value model.query
          , onInput UpdateQuery
          ]
          []
      , button
        [ type_ "submit"
        , onClick Search
        ]
        [ text "Search" ]
      ]


searchResults : Model -> Html Msg
searchResults model =
  case model.searchStatus of
    Loading -> loadingSearchResults model
    Failure -> failureSearchResults model
    Success -> successSearchResults model


loadingSearchResults : Model -> Html Msg
loadingSearchResults model =
  div [] [ text ("Loading " ++ model.query) ]


failureSearchResults : Model -> Html Msg
failureSearchResults model =
  div [] [ text "Could not load results. Please try again later." ]


successSearchResults : Model -> Html Msg
successSearchResults model =
  case model.searchResults of
    Nothing ->
      text ""
    Just results ->
      div
        []
        [ text ("Results for " ++ model.query)
        , text results.typeInfo.id
        , text results.typeInfo.name
        ]


onClick : msg -> Html.Styled.Attribute msg
onClick msg =
  custom "click"
    ( Json.Decode.succeed
      { message = msg
      , preventDefault = True
      , stopPropagation = True
      }
    )


-- HTTP


type alias TypeApiResult =
  { id: String
  , name: String
  -- , relationships: List TypeApiResult    
  }


mapApiResult : TypeApiResult -> TypeResult
mapApiResult apiResult =
  { typeInfo = { id = apiResult.id, name = apiResult.name }
  -- , relationships = []
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
  Json.Decode.map2 TypeApiResult
    (field "type" string)
    (field "name" string)


