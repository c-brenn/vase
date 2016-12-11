module Models exposing (..)

import Routing
import Set exposing(Set(..))

type alias File      = String
type alias Directory = String

type alias Model =
  { cwd         : Routing.Route
  , files       : Set File
  , directories : Set Directory
  , loading     : Bool
  }

initialModel : Routing.Route -> Model
initialModel route = Model route Set.empty Set.empty True
