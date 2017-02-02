module Directory exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (class, href)
import FontAwesome
import Util            exposing ((</>))

type alias Directory = String

view : Directory -> Directory -> Html msg
view basePath directory =
        div
          [ class "block box-item" ]
          [ a
              [ href ("#" ++ basePath </> directory) ]
              [ folderIcon, text directory ]
          ]

folderIcon =
  FontAwesome.makeIcon FontAwesome.folder
