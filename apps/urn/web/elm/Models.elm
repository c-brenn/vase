module Models exposing (..)

import Routing
import Set exposing(Set(..))

type alias File      = String
type alias Directory = String

type alias Model =
  { cwd         : Routing.Route
  , files       : Set File
  , directories : Set Directory
  , directoryInput : String
  , loading     : Bool
  }

initialModel : Routing.Route -> Model
initialModel route =
    { cwd = route
    , files = Set.empty
    , directories = Set.empty
    , directoryInput = ""
    , loading = True
    }
