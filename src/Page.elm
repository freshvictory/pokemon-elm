module Page exposing
  ( Details
  , view
  )


import Browser
import Css exposing (..)
import Html.Styled exposing
  ( Html
  , Attribute
  , toUnstyled
  , map
  , main_
  , div
  )
import Html.Styled.Attributes exposing (css, id)



-- NODE


type alias Details msg =
  { title: String
  , attrs: List (Attribute msg)
  , body: List (Html msg)
  }



-- VIEW


view : (a -> msg) -> Details a -> Browser.Document msg
view toMsg details =
  { title = details.title
  , body = [ viewApp toMsg details.attrs details.body |> toUnstyled ]
  }


viewApp : (a -> msg) -> List (Attribute a) -> List (Html a) -> Html msg
viewApp toMsg attrs body =
  div
    [ id "top"
    , css
      [ width (pct 100)
      , height (pct 100)
      , position fixed
      , property "user-select" "none"
      , property "-moz-user-select" "none"
      , property "-webkit-user-select" "none"
      , property "-ms-user-select" "none"
      ]
    ]
    [ map toMsg (viewBody attrs body)
    ]


viewBody : List (Attribute msg) -> List (Html msg) -> Html msg
viewBody attrs body =
  main_
    attrs
    body
