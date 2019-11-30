module Page.Type exposing (Msg, Model, init, update, view)


import Css exposing (..)
import Html.Styled exposing
  ( Html
  , div
  , h1
  , text
  , tr
  , td
  )
import Html.Styled.Attributes exposing (css)


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
    [ resultsTable info.relationships
    ]



resultsTable : TypeRelationships -> Html Msg
resultsTable relationships =
  Html.Styled.table
    [ css
      [ borderCollapse collapse
      , tableLayout fixed
      , color (hex "111")
      ]
    ]
    [ tr [ css [ backgroundColor (hex "69c423") ] ]
      [ td [ css tableDataStyle ] [ text "Effective against" ]
      , displayResults relationships.effectiveAgainst
      ]
    , tr [ css [ backgroundColor (hex "f9ed63") ] ]
      [ td [ css tableDataStyle ] [ text "Weak against" ]
      , displayResults relationships.weakAgainst
      ]
    , tr [ css [ backgroundColor (hex "20c0f9") ] ]
      [ td [ css tableDataStyle ] [ text "Resistant to" ]
      , displayResults relationships.resistantTo
      ]
    , tr [ css [ backgroundColor (hex "ffa500") ] ]
      [ td [ css tableDataStyle ] [ text "Counters" ]
      , displayResults relationships.counters
      ]
    ]


tableDataStyle : List Style
tableDataStyle =
  [ padding (px 20)
  , textAlign center
  ]


displayResults : List Type -> Html Msg
displayResults types =
  td [ css tableDataStyle ]
    [ text (
      if List.isEmpty types then
        "--"
      else
        String.join ", " (List.map (\t -> (getTypeInfo t).name) types)
      )
    ]
