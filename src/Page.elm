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
  , header
  , main_
  , a
  , div
  , nav
  , img
  )
import Html.Styled.Attributes exposing (css, src, href)


import Theme exposing (images)



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
    []
    [ viewHeader
    , map toMsg (viewBody attrs body)
    ]



viewHeader : Html msg
viewHeader =
  header
    []
    [ nav
      [ css
        [ borderBottom3 (px 1) solid (hex "e6bc2f")
        , paddingTop (px 22)
        , paddingBottom (px 20)
        , margin zero
        , marginBottom (px 25)
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


viewBody : List (Attribute msg) -> List (Html msg) -> Html msg
viewBody attrs body =
  main_
    attrs
    body
