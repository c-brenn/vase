module Models exposing (..)

import Routing

type alias Model = { cwd : Routing.Route }

initialModel : Routing.Route -> Model
initialModel route = Model route
