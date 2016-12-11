module Messages exposing (..)

import Navigation exposing (Location)
import Models     exposing (File, Directory)

type Msg
  = OnLocationChange Location
  | DirectoryListing (List Directory) (List File)
  | NoOp
