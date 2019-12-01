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
import Type exposing (Type, TypeInfo, TypeRelationships, getTypeInfo)


type Msg
  = NoOp


type alias Model =
  { t : Type
  , typeInfo : TypeInfo
  }


init : Type -> ( Model, Cmd Msg )
init t =
  ( { t = t
    , typeInfo = getTypeInfo t
    }
  , Cmd.none
  )


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
  case msg of
    NoOp -> ( model, Cmd.none )


view : Model -> Page.Details Msg
view model =
  { title = model.typeInfo.name
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
    [ viewTypeHeader model.typeInfo
    , viewTypeRelationships model.typeInfo
    ]


viewTypeHeader : TypeInfo -> Html Msg
viewTypeHeader info =
  h1
    []
    [ text info.name
    ]


viewTypeRelationships : TypeInfo -> Html Msg
viewTypeRelationships info =
  div
    []
    [ viewTypeRelationship "Strong against" info.relationships.effectiveAgainst
    , viewTypeRelationship "Weak against" info.relationships.weakAgainst
    , viewTypeRelationship "No effect on" info.relationships.ineffectiveAgainst
    , viewTypeRelationship "Resistant to" info.relationships.resistantTo
    , viewTypeRelationship "Counters" info.relationships.counters
    ]


viewTypeRelationship : String -> List Type -> Html Msg
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
      ( List.map viewTypeLink types )
    ]
