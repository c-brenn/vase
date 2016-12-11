module Messages exposing (..)

import Navigation exposing (Location)
import Models     exposing (File, Directory)
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
  | NoOp
