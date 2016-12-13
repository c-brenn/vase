module File exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (class)
import Html.Events     exposing (onClick)
import FontAwesome
import Messages        exposing (Msg(..))

type alias File = String

view : File -> Html Msg
view file =
  div
    [ class "block box-item" ]
    [ span
        []
        [ div [ class "left"  ] [ fileIcon, text file ]
        , div [ class "right" ] [ downloadIcon, deleteIcon file ]
        ]
    ]

fileIcon =
  FontAwesome.makeIcon FontAwesome.file_text_o

downloadIcon =
  FontAwesome.makeIcon FontAwesome.download

deleteIcon file =
  span [ onClick (Delete file), class "elm-button" ]
    [ FontAwesome.makeIcon FontAwesome.delete ]
