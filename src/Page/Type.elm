module Page.Type exposing (Msg, Model, init, update, view)


import Page
import Type exposing (Type, TypeInfo, getTypeInfo)


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
    [
    ]
  }
