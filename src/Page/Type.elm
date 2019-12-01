module Page.Type exposing (Msg, Model, init, update, view)


import Css exposing (..)
import Html.Styled exposing
  ( Html
  , div
  , h1
  , h2
  , text
  )
import Html.Styled.Attributes exposing (css)


import HtmlHelper exposing (..)
import Page
import Theme exposing (colors)
import Type exposing (Type, SubType, TypeRelationships, fromSubType)


type Msg
  = NoOp


type Viewing
  = Against
  | With


type alias Model =
  { t : Type
  , viewing: Viewing
  }


init : Type -> ( Model, Cmd Msg )
init t =
  ( { t = t
    , viewing = Against
    }
  , Cmd.none
  )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )


view : Model -> Page.Details Msg
view model =
  { title = model.t.name
  , attrs = []
  , body =
    [ viewType model
    ]
  }


viewType : Model -> Html Msg
viewType model =
  div
    [
    ]
    [ viewTypeHeader model.t
    , viewTypeRelationships model
    ]


viewTypeHeader : Type -> Html Msg
viewTypeHeader t =
  div
    [ css
      [ displayFlex
      , alignItems center
      , backgroundColor (colors.typeBackground t.primary)
      , padding (px 10)
      ]
    ]
    [ viewTypeLink t
    , h1
      [ css
        [ paddingLeft (px 10)
        , margin zero
        ]
      ]
      [ text t.name ]
    ]


viewTypeRelationships : Model -> Html Msg
viewTypeRelationships model =
  div
    [ css
      [ margin (px 20)
      ]
    ]
    [ case model.viewing of
      Against ->
        viewBattlingAgainst model.t
      With ->
        viewBattlingWith model.t
    ]


viewBattlingWith : Type -> Html Msg
viewBattlingWith t =
  div
    []
    [ viewTypeRelationship "Good against" colors.effectiveAgainst colors.effectiveAgainstLight t.relationships.effectiveAgainst
    , viewTypeRelationship "Bad against" colors.weakAgainst colors.weakAgainstLight t.relationships.weakAgainst
    , viewTypeRelationship "No effect against" colors.ineffectiveAgainst colors.ineffectiveAgainstLight t.relationships.ineffectiveAgainst
    ]


viewBattlingAgainst : Type -> Html Msg
viewBattlingAgainst t =
  div
    []
    [ viewTypeRelationship "Counters" colors.counters colors.countersLight t.relationships.counters
    , viewTypeRelationship "Stay away from" colors.resistantTo colors.resistantToLight t.relationships.resistantTo
    ]


viewTypeRelationship :String -> Color -> Color -> List SubType -> Html Msg
viewTypeRelationship headerText colorDark colorLight types =
  case types of
    [] ->
      text ""
    _ ->
      div
        [ css
          [ marginBottom (px 20)
          , position relative
          , borderRadius (px 20)
          ]
        ]
        [ h2
          [ css
            [ fontSize (px 16)
            , margin zero
            , lineHeight (num 1)
            , borderTopLeftRadius inherit
            , borderTopRightRadius inherit
            , padding2 (px 10) (px 15)
            , border3 (px 2) solid colorDark
            , borderBottom zero
            , backgroundColor colorDark
            ]
          ]
          [ text headerText
          ]
        , div
          [ css
            [ displayGrid
            , gridGap 15
            , property "grid-template-columns" "repeat(auto-fit, minmax(60px, 1fr))"
            , padding (px 15)
            , borderBottomLeftRadius inherit
            , borderBottomRightRadius inherit
            , border3 (px 2) solid colorDark
            -- , backgroundColor colorLight
            , borderTop zero
            ]
          ]
          ( List.map (fromSubType >> viewTypeGridItem) types )
        ]


viewTypeGridItem : Type -> Html Msg
viewTypeGridItem t =
  div
    [ css
      [ displayGrid
      , alignItems center
      , justifyContent center
      ]
    ]
    [ viewTypeLink t
    ]
