module View exposing (..)

import Html     exposing (..)
import Messages exposing (Msg(..))
import Models   exposing (Model)
import Routing  exposing (Route)

view : Model -> Html Msg
view model =
  if model.loading then
    spinner
  else
    directoryView model

spinner : Html Msg
spinner = h2 [] [ text "Loading..." ]


directoryView : Model -> Html Msg
directoryView model =
  div
    []
    [ h1 [] [ text ("Current Directory: " ++ model.cwd) ]
    , h3 [] [ text "Directories" ]
    , ul [] (List.map (\x -> li [] [text x]) model.directories)
    , h3 [] [ text "Files" ]
    , ul [] (List.map (\x -> li [] [text x]) model.files)
    ]
