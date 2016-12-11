module Update exposing (..)

import Models   exposing (Model)
import Messages exposing (Msg(..))
import Routing  exposing (parseLocation)
import Socket   exposing (cd)
import Set

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    NoOp ->
      ( model, Cmd.none )

    OnLocationChange location ->
      let
          newCwd = parseLocation location
      in
          ( { model
            | cwd = newCwd
            , loading = True
            }
          , cd newCwd
          )

    DirectoryListing directories files ->
      ( { model
        | directories = directories
        , files = files
        , loading = False
        }
      , Cmd.none
      )

    PresenceDiff diff ->
      ( { model
        | directories = Set.diff (Set.union model.directories diff.added_directories) diff.deleted_directories
        , files       = Set.diff (Set.union model.files diff.added_files) diff.deleted_files
        }
      , Cmd.none
      )

