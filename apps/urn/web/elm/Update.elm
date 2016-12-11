module Update exposing (..)

import Models   exposing (Model)
import Messages exposing (Msg(..))
import Routing  exposing (parseLocation)
import Socket   exposing (cd)

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
        | directories = directories |> List.sort
        , files = files |> List.sort
        , loading = False
        }
      , Cmd.none
      )

