module Page.Home exposing (Msg, Model, init, update, view)

import Css exposing (..)
import Html.Styled exposing
  ( Html
  , text
  , ul
  , li
  , img
  , a
  )
import Html.Styled.Attributes exposing (css, href, src, title)

import HtmlHelper exposing (..)
import Page
import Theme exposing (colors)
import Type exposing (Type(..), getTypeInfo)



type Msg
  = NoOp


type alias Model =
  { 
  }


init : ( Model, Cmd Msg )
init =
  ( {}, Cmd.none )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )


view : Model -> Page.Details Msg
view model =
  { title = "Home"
  , attrs = []
  , body =
    [ viewTypeList model
    ]
  }


viewTypeList : Model -> Html Msg
viewTypeList model =
  ul
    [ css
      [ listStyleReset
      , displayGrid
      , gridGap 20
      , property "grid-template-columns" "repeat(auto-fit, minmax(60px, 1fr))"
      , margin (px 20)
      ]
    ]
    ( List.map
      viewTypeGridItem
      [ Normal, Fighting, Flying, Poison, Ground, Rock, Bug, Ghost, Steel, Fire, Water, Grass, Electric, Psychic, Ice, Dragon, Fairy, Dark ] )


viewTypeGridItem : Type -> Html Msg
viewTypeGridItem t =
  li
    [ css
      [ displayGrid
      , alignItems center
      , justifyContent center
      ]
    ]
    [ viewType t
    ]


viewType : Type -> Html Msg
viewType t =
  let
    typeInfo = getTypeInfo t
  in
    a
      [ href ( "type/" ++ typeInfo.id )
      , title typeInfo.name
      , css
        [ aStyleReset
        , padding (px 10)
        , boxSizing borderBox
        , backgroundColor (colors.typeBackground t)
        , borderRadius (pct 50)
        , width (px 60)
        , height (px 60)
        ]
      ]
      [ img
        [ src ( "images/type-" ++ typeInfo.id ++ ".png" )
        , css
          [ height (px 40)
          , width (px 40)
          ]
        ]
        []
      ]

