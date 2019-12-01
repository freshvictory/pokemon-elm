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
import Theme exposing (colors, images)
import Type exposing (..)



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
      [ Type.normal, fighting, flying, poison, ground, rock, bug, ghost, steel, fire, water, grass, electric, psychic, ice, dragon, fairy, dark ] )


viewTypeGridItem : Type -> Html Msg
viewTypeGridItem t =
  li
    [ css
      [ displayGrid
      , alignItems center
      , justifyContent center
      ]
    ]
    [ viewTypeLink t
    ]

