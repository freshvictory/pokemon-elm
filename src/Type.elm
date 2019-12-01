module Type exposing (..)


type SubType
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


type alias Type =
  { id: String
  , primary: SubType
  , secondary: Maybe SubType
  , name: String
  , relationships: TypeRelationships
  }


type alias TypeRelationships =
  { effectiveAgainst: List SubType
  , weakAgainst: List SubType
  , ineffectiveAgainst: List SubType
  , resistantTo: List SubType
  , counters: List SubType
  }


normal : Type
normal =
  { id = "normal"
  , primary = Normal
  , secondary = Nothing
  , name = "Normal"
  , relationships =
    { effectiveAgainst = [ ]
    , weakAgainst = [ Rock, Steel ]
    , ineffectiveAgainst = [ Ghost ]
    , resistantTo = [ Ghost ]
    , counters = [ Fighting ]
    }
  }


fighting : Type
fighting =
  { id = "fighting"
  , primary = Fighting
  , secondary = Nothing
  , name = "Fighting"
  , relationships =
    { effectiveAgainst = [ Normal, Rock, Steel, Ice, Dark ]
    , weakAgainst = [ Flying, Poison, Psychic, Bug, Fairy ]
    , ineffectiveAgainst = [ Ghost ]
    , resistantTo = [ Rock, Bug, Dark ]
    , counters = [ Flying, Psychic, Fairy ]
    }
  }


flying : Type
flying =
  { id = "flying"
  , primary = Flying
  , secondary = Nothing
  , name = "Flying"
  , relationships =
    { effectiveAgainst = [ Fighting, Bug, Grass ]
    , weakAgainst = [ Rock, Steel, Electric ]
    , ineffectiveAgainst = []
    , resistantTo = [ Fighting, Ground, Bug, Grass ]
    , counters = [ Rock, Electric, Ice ]
    }
  }


poison : Type
poison =
  { id = "poison"
  , primary = Poison
  , secondary = Nothing
  , name = "Poison"
  , relationships =
    { effectiveAgainst = [ Grass, Fairy ]
    , weakAgainst = [ Poison, Ground, Rock, Ghost ]
    , ineffectiveAgainst = [ Steel ]
    , resistantTo = [ Fighting, Poison, Grass, Fairy ]
    , counters = [ Ground, Psychic ]
    }
  }


ground : Type
ground =
  { id = "ground"
  , primary = Ground
  , secondary = Nothing
  , name = "Ground"
  , relationships =
    { effectiveAgainst = [ Poison, Rock, Steel, Fire, Electric ]
    , weakAgainst = [ Bug, Grass ]
    , ineffectiveAgainst = [ Flying ]
    , resistantTo = [ Poison, Rock, Electric ]
    , counters = [ Water, Grass, Ice ]
    }
  }


rock : Type
rock =
  { id = "rock"
  , primary = Rock
  , secondary = Nothing
  , name = "Rock"
  , relationships =
    { effectiveAgainst = [ Flying, Bug, Fire, Ice ]
    , weakAgainst = [ Fighting, Ground, Steel ]
    , ineffectiveAgainst = []
    , resistantTo = [ Normal, Flying, Poison, Fire ]
    , counters = [ Fighting, Ground, Steel, Water, Grass ]
    }
  }


bug : Type
bug =
  { id = "bug"
  , primary = Bug
  , secondary = Nothing
  , name = "Bug"
  , relationships =
    { effectiveAgainst = [ Grass, Psychic, Dark ]
    , weakAgainst = [ Fighting, Flying, Poison, Ghost, Steel, Fire, Fairy ]
    , ineffectiveAgainst = []
    , resistantTo = [ Fighting, Ground, Grass ]
    , counters = [ Flying, Rock, Fire ]
    }
  }


ghost : Type
ghost =
  { id = "ghost"
  , primary = Ghost
  , secondary = Nothing
  , name = "Ghost"
  , relationships =
    { effectiveAgainst = [ Ghost, Psychic ]
    , weakAgainst = [ Dark ]
    , ineffectiveAgainst = [ Normal ]
    , resistantTo = [ Normal, Fighting, Poison, Bug ]
    , counters = [ Ghost, Dark ]
    }
  }


steel : Type
steel =
  { id = "steel"
  , primary = Steel
  , secondary = Nothing
  , name = "Steel"
  , relationships =
    { effectiveAgainst = [ Rock, Ice, Fairy ]
    , weakAgainst = [ Steel, Fire, Water, Electric ]
    , ineffectiveAgainst = []
    , resistantTo = [ Normal, Flying, Poison, Rock, Bug, Steel, Grass, Psychic, Ice, Dragon, Fairy ]
    , counters = [ Fighting, Ground, Fire ]
    }
  }


fire : Type
fire =
  { id = "fire"
  , primary = Fire
  , secondary = Nothing
  , name = "Fire"
  , relationships =
    { effectiveAgainst = [ Bug, Steel, Grass, Ice ]
    , weakAgainst = [ Rock, Fire, Water, Dragon ]
    , ineffectiveAgainst = []
    , resistantTo = [ Bug, Steel, Fire, Grass, Ice ]
    , counters = [ Ground, Rock, Water ]
    }
  }


water : Type
water =
  { id = "water"
  , primary = Water
  , secondary = Nothing
  , name = "Water"
  , relationships =
    { effectiveAgainst = [ Ground, Rock, Fire ]
    , weakAgainst = [ Water, Grass, Dragon ]
    , ineffectiveAgainst = []
    , resistantTo = [ Steel, Fire, Water, Ice ]
    , counters = [ Grass, Electric ]
    }
  }


grass : Type
grass =
  { id = "grass"
  , primary = Grass
  , secondary = Nothing
  , name = "Grass"
  , relationships =
    { effectiveAgainst = [ Ground, Rock, Water ]
    , weakAgainst = [ Flying, Poison, Bug, Steel, Fire, Grass, Dragon ]
    , ineffectiveAgainst = []
    , resistantTo = [ Ground, Water, Grass, Electric ]
    , counters = [ Flying, Poison, Bug, Fire, Ice ]
    }
  }


electric : Type
electric =
  { id = "electric"
  , primary = Electric
  , secondary = Nothing
  , name = "Electric"
  , relationships =
    { effectiveAgainst = [ Flying, Water ]
    , weakAgainst = [ Grass, Electric, Dragon ]
    , ineffectiveAgainst = [ Ground ]
    , resistantTo = [ Flying, Steel, Electric ]
    , counters = [ Ground ]
    }
  }


psychic : Type
psychic =
  { id = "psychic"
  , primary = Psychic
  , secondary = Nothing
  , name = "Psychic"
  , relationships =
    { effectiveAgainst = [ Fighting, Poison ]
    , weakAgainst = [ Steel, Psychic ]
    , ineffectiveAgainst = [ Dark ]
    , resistantTo = [ Fighting, Psychic ]
    , counters = [ Bug, Ghost, Dark ]
    }
  }


ice : Type
ice =
  { id = "ice"
  , primary = Ice
  , secondary = Nothing
  , name = "Ice"
  , relationships =
    { effectiveAgainst = [ Flying, Ground, Grass, Dragon ]
    , weakAgainst = [ Steel, Fire, Water, Ice ]
    , ineffectiveAgainst = []
    , resistantTo = [ Ice ]
    , counters = [ Fighting, Rock, Steel, Fire ]
    }
  }


dragon : Type
dragon =
  { id = "dragon"
  , primary = Dragon
  , secondary = Nothing
  , name = "Dragon"
  , relationships =
    { effectiveAgainst = [ Dragon ]
    , weakAgainst = [ Steel ]
    , ineffectiveAgainst = [ Fairy ]
    , resistantTo = [ Fire, Water, Grass, Electric ]
    , counters = [ Ice, Dragon, Fairy ]
    }
  }


fairy : Type
fairy =
  { id = "fairy"
  , primary = Fairy
  , secondary = Nothing
  , name = "Fairy"
  , relationships =
    { effectiveAgainst = [ Fighting, Dragon, Dark ]
    , weakAgainst = [ Poison, Steel, Fire ]
    , ineffectiveAgainst = []
    , resistantTo = [ Fighting, Bug, Dragon, Dark ]
    , counters = [ Poison, Steel ]
    }
  }


dark : Type
dark =
  { id = "dark"
  , primary = Dark
  , secondary = Nothing
  , name = "Dark"
  , relationships =
    { effectiveAgainst = [ Ghost, Psychic ]
    , weakAgainst = [ Fighting, Dark, Fairy ]
    , ineffectiveAgainst = []
    , resistantTo = [ Ghost, Psychic, Dark ]
    , counters = [ Fighting, Bug, Fairy ]
    }
  }


dualType : Type -> Type -> Type
dualType primary secondary =
  { id = primary.id ++ "," ++ secondary.id
  , primary = primary.primary
  , secondary = Just secondary.primary
  , name = primary.name ++ " / " ++ secondary.name
  , relationships = calculateDualTypeRelationships primary.relationships secondary.relationships
  }


calculateDualTypeRelationships : TypeRelationships -> TypeRelationships -> TypeRelationships
calculateDualTypeRelationships primary secondary =
  primary


fromSubType : SubType -> Type
fromSubType s =
  case s of
    Normal ->
      normal
    Fighting ->
      fighting
    Flying ->
      flying
    Poison ->
      poison
    Ground ->
      ground
    Rock ->
      rock
    Bug ->
      bug
    Ghost ->
      ghost
    Steel ->
      steel
    Fire ->
      fire
    Water ->
      water
    Grass ->
      grass
    Electric ->
      electric
    Psychic ->
      psychic
    Ice ->
      ice
    Dragon ->
      dragon
    Fairy ->
      fairy
    Dark ->
      dark


fromString : String -> Maybe Type
fromString s =
  case s of
    "normal" -> Just normal
    "fighting" -> Just fighting
    "flying" -> Just flying
    "poison" -> Just poison
    "ground" -> Just ground
    "rock" -> Just rock
    "bug" -> Just bug
    "ghost" -> Just ghost
    "steel" -> Just steel
    "fire" -> Just fire
    "water" -> Just water
    "grass" -> Just grass
    "electric" -> Just electric
    "psychic" -> Just psychic
    "ice" -> Just ice
    "dragon" -> Just dragon
    "fairy" -> Just fairy
    "dark" -> Just dark
    _ -> Nothing
