module Models exposing (..)

import Routing
import Set       exposing (Set(..))
import File      exposing (File)
import Directory exposing (Directory)


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
