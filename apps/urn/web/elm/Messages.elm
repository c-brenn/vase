module Messages exposing (..)

import Navigation exposing (Location)
import Set        exposing (Set(..))

type alias File = String
type alias Directory = String

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
  | FileName String
  | NewDirectory
  | Upload
  | Submit String String
  | Delete File
  | NoOp
