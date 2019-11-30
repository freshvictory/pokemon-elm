module Type exposing (Type, getTypeInfo)


type Type
  = Normal
  | Fighting
  | Flying
  | Poison
  | Ground
  | Rock
  | Bug
  | Ghost
  | Steel
  | Fire
  | Water
  | Grass
  | Electric
  | Psychic
  | Ice
  | Dragon
  | Fairy
  | Dark


type alias TypeInfo =
  { id: String
  , name: String
  , relationships: TypeRelationships
  }


type alias TypeRelationships =
  { effectiveAgainst: List Type
  , weakAgainst: List Type
  , resistantTo: List Type
  , counters: List Type
  }


getTypeInfo : Type -> TypeInfo
getTypeInfo t =
  case t of
    Normal ->
      { id = "normal"
      , name = "Normal"
      , relationships = getTypeRelationships Normal
      }
    Fighting ->
      { id = "fighting"
      , name = "Fighting"
      , relationships = getTypeRelationships Fighting
      }
    Flying ->
      { id = "flying"
      , name = "Flying"
      , relationships = getTypeRelationships Flying
      }
    Poison ->
      { id = "poison"
      , name = "Poison"
      , relationships = getTypeRelationships Poison
      }
    Ground ->
      { id = "ground"
      , name = "Ground"
      , relationships = getTypeRelationships Ground
      }
    Rock ->
      { id = "rock"
      , name = "Rock"
      , relationships = getTypeRelationships Rock
      }
    Bug ->
      { id = "bug"
      , name = "Bug"
      , relationships = getTypeRelationships Bug
      }
    Ghost ->
      { id = "ghost"
      , name = "Ghost"
      , relationships = getTypeRelationships Ghost
      }
    Steel ->
      { id = "steel"
      , name = "Steel"
      , relationships = getTypeRelationships Steel
      }
    Fire ->
      { id = "fire"
      , name = "Fire"
      , relationships = getTypeRelationships Fire
      }
    Water ->
      { id = "water"
      , name = "Water"
      , relationships = getTypeRelationships Water
      }
    Grass ->
      { id = "grass"
      , name = "Grass"
      , relationships = getTypeRelationships Grass
      }
    Electric ->
      { id = "electric"
      , name = "Electric"
      , relationships = getTypeRelationships Electric
      }
    Psychic ->
      { id = "psychic"
      , name = "Psychic"
      , relationships = getTypeRelationships Psychic
      }
    Ice ->
      { id = "ice"
      , name = "Ice"
      , relationships = getTypeRelationships Ice
      }
    Dragon ->
      { id = "dragon"
      , name = "Dragon"
      , relationships = getTypeRelationships Dragon
      }
    Fairy ->
      { id = "fairy"
      , name = "Fairy"
      , relationships = getTypeRelationships Fairy
      }
    Dark ->
      { id = "dark"
      , name = "Dark"
      , relationships = getTypeRelationships Dark
      }


getTypeRelationships : Type -> TypeRelationships
getTypeRelationships t =
  case t of
    Normal ->
      { effectiveAgainst = [ ]
      , weakAgainst = [ Rock, Ghost, Steel ]
      , resistantTo = [ Ghost ]
      , counters = [ Fighting ]
      }
    Fighting ->
      { effectiveAgainst = [ Normal, Rock, Steel, Ice, Dark ]
      , weakAgainst = [ Flying, Poison, Psychic, Bug, Ghost, Fairy ]
      , resistantTo = [ Rock, Bug, Dark ]
      , counters = [ Flying, Psychic, Fairy ]
      }
    Flying ->
      { effectiveAgainst = [ Fighting, Bug, Grass ]
      , weakAgainst = [ Rock, Steel, Electric ]
      , resistantTo = [ Fighting, Ground, Bug, Grass ]
      , counters = [ Rock, Electric, Ice ]
      }
    Poison ->
      { effectiveAgainst = [ Grass, Fairy ]
      , weakAgainst = [ Poison, Ground, Rock, Ghost, Steel ]
      , resistantTo = [ Fighting, Poison, Grass, Fairy ]
      , counters = [ Ground, Psychic ]
      }
    Ground ->
      { effectiveAgainst = [ Poison, Rock, Steel, Fire, Electric ]
      , weakAgainst = [ Flying, Bug, Grass ]
      , resistantTo = [ Poison, Rock, Electric ]
      , counters = [ Water, Grass, Ice ]
      }
    Rock ->
      { effectiveAgainst = [ Flying, Bug, Fire, Ice ]
      , weakAgainst = [ Fighting, Ground, Steel ]
      , resistantTo = [ Normal, Flying, Poison, Fire ]
      , counters = [ Fighting, Ground, Steel, Water, Grass ]
      }
    Bug ->
      { effectiveAgainst = [ Grass, Psychic, Dark ]
      , weakAgainst = [ Fighting, Flying, Poison, Ghost, Steel, Fire, Fairy ]
      , resistantTo = [ Fighting, Ground, Grass ]
      , counters = [ Flying, Rock, Fire ]
      }
    Ghost ->
      { effectiveAgainst = [ Ghost, Psychic ]
      , weakAgainst = [ Normal, Dark ]
      , resistantTo = [ Normal, Fighting, Poison, Bug ]
      , counters = [ Ghost, Dark ]
      }
    Steel ->
      { effectiveAgainst = [ Rock, Ice, Fairy ]
      , weakAgainst = [ Steel, Fire, Water, Electric ]
      , resistantTo = [ Normal, Flying, Poison, Rock, Bug, Steel, Grass, Psychic, Ice, Dragon, Fairy ]
      , counters = [ Fighting, Ground, Fire ]
      }
    Fire ->
      { effectiveAgainst = [ Bug, Steel, Grass, Ice ]
      , weakAgainst = [ Rock, Fire, Water, Dragon ]
      , resistantTo = [ Bug, Steel, Fire, Grass, Ice ]
      , counters = [ Ground, Rock, Water ]
      }
    Water ->
      { effectiveAgainst = [ Ground, Rock, Fire ]
      , weakAgainst = [ Water, Grass, Dragon ]
      , resistantTo = [ Steel, Fire, Water, Ice ]
      , counters = [ Grass, Electric ]
      }
    Grass ->
      { effectiveAgainst = [ Ground, Rock, Water ]
      , weakAgainst = [ Flying, Poison, Bug, Steel, Fire, Grass, Dragon ]
      , resistantTo = [ Ground, Water, Grass, Electric ]
      , counters = [ Flying, Poison, Bug, Fire, Ice ]
      }
    Electric ->
      { effectiveAgainst = [ Flying, Water ]
      , weakAgainst = [ Ground, Grass, Electric, Dragon ]
      , resistantTo = [ Flying, Steel, Electric ]
      , counters = [ Ground ]
      }
    Psychic ->
      { effectiveAgainst = [ Fighting, Poison ]
      , weakAgainst = [ Steel, Psychic, Dark ]
      , resistantTo = [ Fighting, Psychic ]
      , counters = [ Bug, Ghost, Dark ]
      }
    Ice ->
      { effectiveAgainst = [ Flying, Ground, Grass, Dragon ]
      , weakAgainst = [ Steel, Fire, Water, Ice ]
      , resistantTo = [ Ice ]
      , counters = [ Fighting, Rock, Steel, Fire ]
      }
    Dragon ->
      { effectiveAgainst = [ Dragon ]
      , weakAgainst = [ Steel, Fairy ]
      , resistantTo = [ Fire, Water, Grass, Electric ]
      , counters = [ Ice, Dragon, Fairy ]
      }
    Fairy ->
      { effectiveAgainst = [ Fighting, Dragon, Dark ]
      , weakAgainst = [ Poison, Steel, Fire ]
      , resistantTo = [ Fighting, Bug, Dragon, Dark ]
      , counters = [ Poison, Steel ]
      }
    Dark ->
      { effectiveAgainst = [ Ghost, Psychic ]
      , weakAgainst = [ Fighting, Dark, Fairy ]
      , resistantTo = [ Ghost, Psychic, Dark ]
      , counters = [ Fighting, Bug, Fairy ]
      }


getMultiTypeRelationships : Type -> Type -> TypeRelationships
getMultiTypeRelationships primary secondary =
  let
    primaryRelationships = getTypeRelationships primary
    secondaryRelationships = getTypeRelationships secondary
  in
    { effectiveAgainst = []
    , weakAgainst = []
    , resistantTo = []
    , counters = []
    }
