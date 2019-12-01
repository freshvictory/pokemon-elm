module Theme exposing (colors, images)

import Css exposing (Color, hex)
import Type exposing (Type, SubType(..))


type alias Images =
  { logo: String
  , typeIcon: Type -> String
  }


images : Images
images =
  { logo = "/images/logo-pokemon.png"
  , typeIcon = iconForType
  }


iconForType : Type -> String
iconForType typeInfo =
  "/images/type-" ++ typeInfo.id ++ ".png"


type alias Colors =
  { background : Color
  , menuBackground : Color
  , text : Color
  , border : Color
  , buttonBackground : Color
  , typeForeground : SubType -> Color
  , typeBackground : SubType -> Color
  }


colors : Colors
colors =
  { background = hex "FFF"
  , menuBackground = hex "EEE"
  , text = hex "000"
  , border = hex "CCC"
  , buttonBackground = hex "CCC"
  , typeForeground = getTypeForegroundColor
  , typeBackground = getTypeBackgroundColor
  }


getTypeForegroundColor : SubType -> Color
getTypeForegroundColor t =
  hex (getTypeColor t)


getTypeBackgroundColor : SubType -> Color
getTypeBackgroundColor t =
  hex (getTypeColor t ++ "55")


getTypeColor : SubType -> String
getTypeColor t =
  case t of
    Normal ->
      "999EA0"
    Fighting ->
      "D6425F"
    Flying ->
      "96b1e3"
    Poison ->
      "b663ce"
    Ground ->
      "d78656"
    Rock ->
      "ccbe8e"
    Bug ->
      "97c32f"
    Ghost ->
      "606dba"
    Steel ->
      "5492a1"
    Fire ->
      "FF9C54"
    Water ->
      "559bd9"
    Grass ->
      "5fba57"
    Electric ->
      "f4d543"
    Psychic ->
      "f87378"
    Ice ->
      "79d1c5"
    Dragon ->
      "0876BF"
    Fairy ->
      "ed95e0"
    Dark ->
      "5b5467"

