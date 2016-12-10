module View exposing (..)

import Html     exposing (..)
import Messages exposing (Msg(..))
import Models   exposing (Model)
import Routing  exposing (Route)

view : Model -> Html Msg
view model =
  div
    []
    [ h1 [] [ text "Current Directory" ]
    , h3 [] [ text model.cwd ]
    ]
