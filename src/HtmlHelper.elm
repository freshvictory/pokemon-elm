module HtmlHelper exposing (..)


import Css exposing (..)


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
