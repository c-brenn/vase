module Messages exposing (..)

import Navigation exposing (Location)
import File       exposing (File)
import Directory  exposing (Directory)
import Set        exposing (Set(..))

type alias Diff =
  { added_directories   : Set Directory
  , added_files         : Set File
  , deleted_directories : Set Directory
  , deleted_files       : Set File
  }

type Msg
  = OnLocationChange Location
  | DirectoryListing (Set Directory) (Set File)
  | PresenceDiff Diff
  | DirectoryName String
  | NewDirectory
  | NoOp
