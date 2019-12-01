module HtmlHelper exposing (..)


import Css exposing (..)
import Html.Styled exposing (Html, a, img)
import Html.Styled.Attributes exposing (css, src, href, title)


import Type exposing (Type)
import Theme exposing (colors, images)


listStyleReset : Style
listStyleReset =
  Css.batch
    [ listStyle none
    , margin zero
    , padding zero
    ]


aStyleReset : Style
aStyleReset =
  Css.batch
    [ visited
      [ color inherit
      ]
    , color inherit
    , textDecoration none
    ]


displayGrid : Style
displayGrid =
  property "display" "grid"


gridGap : Int -> Style
gridGap g =
  property "grid-gap" (String.fromInt g ++ "px")


gridRowGap : Int -> Style
gridRowGap g =
  property "grid-row-gap" (String.fromInt g ++ "px")


gridColumnGap : Int -> Style
gridColumnGap g =
  property "grid-column-gap" (String.fromInt g ++ "px")



viewTypeLink : Type -> Html msg
viewTypeLink t =
  a
    [ href ( "/type/" ++ t.id )
    , title t.name
    , css
      [ aStyleReset
      , padding (px 10)
      , boxSizing borderBox
      , backgroundColor (colors.typeBackground t.primary)
      , borderRadius (pct 50)
      , width (px 60)
      , height (px 60)
      , display inlineFlex
      , alignItems center
      , justifyContent center
      ]
    ]
    [ img
      [ src (images.typeIcon t)
      , css
        [ height (px 40)
        , width (px 40)
        ]
      ]
      []
    ]
