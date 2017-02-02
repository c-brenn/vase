module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type alias Route = String


parseLocation : Location -> Route
parseLocation location =
  case location.hash of
    "" -> "/"
    path -> String.dropLeft 1 path -- remove #
