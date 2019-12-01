module Page.Type exposing (Msg, Model, init, update, view)


import Css exposing (..)
import Html.Styled exposing
  ( Html
  , div
  , h1
  , h2
  , a
  , text
  )
import Html.Styled.Attributes exposing (css, href)
import Html.Styled.Events exposing (onClick)
import Html.Styled.Keyed as Keyed


import HtmlHelper exposing (..)
import Page
import Theme exposing (colors)
import Type exposing (Type, SubType, TypeRelationships, fromSubType)


type Msg
  = SwitchView Viewing


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
    SwitchView v ->
      ( { model | viewing = v }, Cmd.none )


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
    [ div
      [ css
        [ property "padding-top" "env(safe-area-inset-top)"
        , backgroundColor (colors.typeBackground model.t.primary)
        , borderBottom3 (px 1) solid (colors.typeBackground model.t.primary)
        ]
      ]
      []
    , viewTypeHeader model.t
    , viewTabsContainer model
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
    [a
      [ href "/"
      , css
        [ aStyleReset
        , fontWeight bold
        , padding (px 5)
        , fontSize (px 24)
        ]
      ]
      [ text "<"]
    , Keyed.node "div" [] [ (t.id, viewTypeLink t) ]
    , h1
      [ css
        [ paddingLeft (px 5)
        , margin zero
        ]
      ]
      [ text t.name ]
    ]


viewTabsContainer : Model -> Html Msg
viewTabsContainer model =
  div
    [ css
      [ margin2 (px 30) auto
      , display block
      , width (pct 80)
      , borderBottom3 (px 1) solid colors.border
      , position relative
      ]
    ]
    [ viewTabs model
    ]


viewTabs : Model -> Html Msg
viewTabs model =
  div
    [ css
      [ displayFlex
      , position absolute
      , top (px -15)
      , left (pct 50)
      , transform (translateX (pct -50))
      ]
    ]
    [ viewTab "Against" Against True model
    , viewTab "With" With False model
    ]


viewTab : String -> Viewing -> Bool -> Model -> Html Msg
viewTab name viewing left model =
  div
    [ onClick (SwitchView viewing)
    , css
      [ cursor pointer
      , padding2 (px 5) (px 10)
      , border3 (px 1) solid colors.border
      , Css.batch
        ( if model.viewing == viewing then
            [ backgroundColor colors.menuBackground ]
          else
            [ backgroundColor colors.background ]
        )
      , Css.batch
        ( if left then
            [ borderTopLeftRadius (px 10)
            , borderBottomLeftRadius (px 10)
            , borderRight zero
            ]
          else
            [ borderTopRightRadius (px 10)
            , borderBottomRightRadius (px 10)
            ]
        )
      ]
    ]
    [ text name
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


viewTypeRelationship : String -> Color -> Color -> List SubType -> Html Msg
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
            , property "grid-template-columns" "repeat(auto-fill, minmax(60px, 1fr))"
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
  Keyed.node
    "div"
    [ css
      [ displayGrid
      , alignItems center
      , justifyContent center
      ]
    ]
    [ (t.id, viewTypeLink t)
    ]
