module File exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (class, href)
import Html.Events     exposing (onClick)
import FontAwesome
import Messages        exposing (Msg(..))
import Util            exposing (..)

type alias File = String
type alias Cwd  = String
type alias Token = String

view : Cwd -> Token -> File -> Html Msg
view cwd token file =
  div
    [ class "block box-item" ]
    [ span
        []
        [ div [ class "left"  ] [ fileIcon, text file ]
        , div [ class "right" ] [ downloadIcon file cwd token, deleteIcon file ]
        ]
    ]

fileIcon =
  FontAwesome.makeIcon FontAwesome.file_text_o

downloadIcon file cwd token =
  let
      fullPath = cwd </> file
      url = "/api/files/read?file=" ++ fullPath ++ "&token=" ++ token
  in
    a [ href url ]
      [
        span [ class "elm-button" ]
          [ FontAwesome.makeIcon FontAwesome.download ]
      ]

deleteIcon file =
  span [ onClick (Delete file), class "elm-button" ]
    [ FontAwesome.makeIcon FontAwesome.delete ]
