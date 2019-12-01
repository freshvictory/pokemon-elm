module Page.Home exposing (Msg, Model, init, update, view)

import Css exposing (..)
import Html.Styled exposing
  ( Html
  , text
  , header
  , nav
  , h1
  , div
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
    [ viewHeader
    , viewContent
    ]
  }



viewHeader : Html msg
viewHeader =
  header
    [ css
      [ property "margin-top" "env(safe-area-inset-top)"
      ]
    ]
    [ nav
      [ css
        [ borderBottom3 (px 1) solid (hex "e6bc2f")
        , paddingTop (px 22)
        , paddingBottom (px 20)
        , margin zero
        ]
      ]
      [ a
        [ href "/" 
        ]
        [ img
          [ src images.logo
          , css [ display block, margin2 zero auto ]
          ] []
        ]
      ]
    ]


viewContent : Html Msg
viewContent =
  div
    [ css
      [ padding (px 20)
      ]
    ]
    [ viewContentHeader
    , viewTypeList
    ]


viewContentHeader : Html Msg
viewContentHeader =
  h1
    [ css
      [ margin4 zero zero (px 20) zero
      , fontSize (px 20)
      , textAlign center
      ]
    ]
    [ text "Choose a Pokemon type!" ]


viewTypeList : Html Msg
viewTypeList =
  ul
    [ css
      [ listStyleReset
      , displayGrid
      , gridGap 20
      , property "grid-template-columns" "repeat(auto-fit, minmax(60px, 1fr))"
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

