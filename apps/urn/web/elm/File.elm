module File exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (class)
import FontAwesome

type alias File = String

view : File -> Html msg
view file =
  div
    [ class "block box-item" ]
    [ span [] [ fileIcon, text file, downloadIcon, deleteIcon ] ]

fileIcon =
  FontAwesome.makeIcon FontAwesome.file_text_o

downloadIcon =
  FontAwesome.makeIcon FontAwesome.download

deleteIcon =
  FontAwesome.makeIcon FontAwesome.delete
