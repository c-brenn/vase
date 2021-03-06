module Update exposing (..)

import Models     exposing (Model)
import Messages   exposing (Msg(..))
import Routing    exposing (parseLocation)
import Socket     exposing (cd)
import Util       exposing ((</>))
import Navigation exposing (newUrl)
import FileServer
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

    DirectoryName dir ->
      ( { model | directoryInput = dir }, Cmd.none )

    FileName file ->
      ( { model | fileInput = file }, Cmd.none )

    NewDirectory ->
      let
          dir = model.directoryInput
      in
          if String.isEmpty dir then
            ( model, Cmd.none )
          else
            (
              { model | directoryInput = "" }
              , newUrl ("#" ++ model.cwd </> dir)
            )

    Upload ->
      let
          fullPath =
            model.cwd </> model.fileInput
      in
          if String.isEmpty model.fileInput then
            ( model, Cmd.none )
          else
            ( model , FileServer.upload  model.host fullPath )

    Submit host path ->
      ({ model| fileInput = "" }, FileServer.submitUploadForm (host, path))

    Delete file ->
      let
          fullPath =
            model.cwd </> file
      in
          ( model, FileServer.delete model.token model.host fullPath )
