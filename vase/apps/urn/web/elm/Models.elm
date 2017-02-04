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
  , token       : String
  }

initialModel : Routing.Route -> String -> String -> Model
initialModel route host token =
    { cwd = route
    , files = Set.empty
    , directories = Set.empty
    , directoryInput = ""
    , fileInput = ""
    , loading = True
    , host = host
    , token = token
    }
