module Models exposing (..)

import Routing

type alias File      = String
type alias Directory = String

type alias Model =
  { cwd         : Routing.Route
  , files       : List File
  , directories : List Directory
  , loading     : Bool
  }

initialModel : Routing.Route -> Model
initialModel route = Model route [] [] True
