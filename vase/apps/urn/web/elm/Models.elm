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
  , fileInput   : String
  , loading     : Bool
  , host        : String
  }

initialModel : Routing.Route -> String -> Model
initialModel route host =
    { cwd = route
    , files = Set.empty
    , directories = Set.empty
    , directoryInput = ""
    , fileInput = ""
    , loading = True
    , host = host
    }
