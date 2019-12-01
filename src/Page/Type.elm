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
import Type exposing (Type, SubType, TypeRelationships, fromSubType)


type Msg
  = NoOp


type alias Model =
  { t : Type
  }


init : Type -> ( Model, Cmd Msg )
init t =
  ( { t = t
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
    [ css
      [ margin (px 20)
      ]
    ]
    [ viewTypeHeader model.t
    , viewTypeRelationships model.t
    ]


viewTypeHeader : Type -> Html Msg
viewTypeHeader t =
  h1
    [ css
      []
    ]
    [ text t.name
    ]


viewTypeRelationships : Type -> Html Msg
viewTypeRelationships t =
  div
    []
    [ viewTypeRelationship "Strong against" t.relationships.effectiveAgainst
    , viewTypeRelationship "Weak against" t.relationships.weakAgainst
    , viewTypeRelationship "No effect on" t.relationships.ineffectiveAgainst
    , viewTypeRelationship "Resistant to" t.relationships.resistantTo
    , viewTypeRelationship "Counters" t.relationships.counters
    ]


viewTypeRelationship : String -> List SubType -> Html Msg
viewTypeRelationship header types =
  div
    []
    [ h2
      []
      [ text header
      ]
    , div
      [ css
        [
        ]
      ]
      ( List.map (fromSubType >> viewTypeLink) types )
    ]
