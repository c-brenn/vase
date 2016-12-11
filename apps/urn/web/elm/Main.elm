module Main exposing (..)

import Messages   exposing (Msg(..))
import Models     exposing (Model, initialModel)
import Navigation exposing (Location)
import Routing    exposing (Route)
import Update     exposing (update)
import View       exposing (view)
import Socket     exposing (directoryEvents, cd)

init : Location -> ( Model, Cmd Msg )
init location =
    let
        currentRoute =
          Routing.parseLocation location
    in
        ( initialModel currentRoute, cd currentRoute )

subscriptions : Model -> Sub Msg
subscriptions model =
  directoryEvents

main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }
