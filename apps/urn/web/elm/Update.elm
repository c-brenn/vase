module Update exposing (..)

import Models   exposing (Model)
import Messages exposing (Msg(..))
import Routing  exposing (parseLocation)

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    OnLocationChange location ->
      let
          newCwd = parseLocation location
      in
          ( { model | cwd = newCwd }, Cmd.none )
