module Theme exposing (colors)

import Css exposing (Color, hex)
import Type exposing (Type, SubType(..))


type alias Colors =
  { background : Color
  , menuBackground : Color
  , text : Color
  , border : Color
  , buttonBackground : Color
  , typeForeground : SubType -> Color
  , typeBackground : SubType -> Color
  , effectiveAgainst : Color
  , ineffectiveAgainst : Color
  , weakAgainst : Color
  , counters : Color
  , resistantTo : Color
  , effectiveAgainstLight : Color
  , ineffectiveAgainstLight : Color
  , weakAgainstLight : Color
  , countersLight : Color
  , resistantToLight : Color
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
  , effectiveAgainst = hex "69c423"
  , ineffectiveAgainst = hex "f78360"
  , weakAgainst = hex "f9ed63"
  , resistantTo = hex "f78360"
  , counters = hex "69c423"
  , effectiveAgainstLight = hex "69c42355"
  , ineffectiveAgainstLight = hex "f7836055"
  , weakAgainstLight = hex "f9ed6355"
  , resistantToLight = hex "f7836055"
  , countersLight = hex "69c42355"
  }


getTypeForegroundColor : SubType -> Color
getTypeForegroundColor t =
  hex (getTypeColor t)


getTypeBackgroundColor : SubType -> Color
getTypeBackgroundColor t =
  hex (getTypeLightColor t)


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


getTypeLightColor : SubType -> String
getTypeLightColor t =
  case t of
    Normal ->
      "DDDFDF"
    Fighting ->
      "F1C0C9"
    Flying ->
      "dce5f6"
    Poison ->
      "e7cbef"
    Ground ->
      "f2d6c6"
    Rock ->
      "eee9d9"
    Bug ->
      "dcebb9"
    Ghost ->
      "cacee8"
    Steel ->
      "c6dbe0"
    Fire ->
      "FFDEC6"
    Water ->
      "c6def2"
    Grass ->
      "c9e8c7"
    Electric ->
      "fbf1c0"
    Psychic ->
      "fdd0d2"
    Ice ->
      "d2f0ec"
    Dragon ->
      "ACD1EA"
    Fairy ->
      "f9dcf5"
    Dark ->
      "c8c6cc"

