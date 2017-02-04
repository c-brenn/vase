module Main exposing (..)

import Messages   exposing (Msg(..))
import Models     exposing (Model, initialModel)
import Navigation exposing (Location)
import Routing    exposing (Route)
import Update     exposing (update)
import View       exposing (view)
import Socket     exposing (directoryEvents, cd)

type alias Flags = { token : String }

init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
          Routing.parseLocation location

        token =
          flags.token

        model =
          initialModel currentRoute location.host token
    in
        ( model, cd currentRoute )

subscriptions : Model -> Sub Msg
subscriptions model =
  directoryEvents

main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
