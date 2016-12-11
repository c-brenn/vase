module View exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (..)
import Messages        exposing (Msg(..))
import Models          exposing (Model)
import Routing         exposing (Route)
import Color           exposing (Color, darkGrey)
import FontAwesome     as FA
import Set

view : Model -> Html Msg
view model =
  let
      contents =
        if model.loading then
          spinner
        else
          directoryListing model
  in
      div
        []
        [ navigator model.cwd
        , contents
        ]

spinner : Html Msg
spinner = h2 [] [ text "Loading..." ]

navigator : String -> Html Msg
navigator path =
  let
      pathSegments
        = String.split "/" path
           |> List.filter (\s -> not (String.isEmpty s))

      hrefs =
        List.scanl (\sub path -> path </> sub) "#" pathSegments

      names =
        FA.home darkGrey 32 :: List.map text pathSegments

      toLink name path =
        a [ href path ] [ name ]

      subfolders =
        List.map2 toLink names hrefs
  in
      div
        [ class "navigator" ]
        (List.intersperse navigatorSeparator subfolders)

navigatorSeparator : Html Msg
navigatorSeparator =
  span [] [ text "/" ]

directoryListing : Model -> Html Msg
directoryListing model =
  let
      directories =
        directoriesView model

      files =
        filesView model

      header =
        div [ class "block box-header" ] [ text "File Navigation" ]
  in
      div
        [ class "box" ]
        (header :: directories ++ files)

directoriesView : Model -> List (Html Msg)
directoriesView model =
  let
      directoryView dir =
        div
          [ class "block box-item" ]
          [ a [ href ("#" ++ model.cwd </> dir) ] [ folderIcon, text dir ] ]
  in
    List.map directoryView (model.directories |> Set.toList)

filesView : Model -> List (Html Msg)
filesView model =
  let
      fileView file =
        div
          [ class "block box-item" ]
          [ span [] [ fileIcon, text file ] ]
  in
      List.map fileView (model.files |> Set.toList)

folderIcon =
  makeIcon FA.folder

fileIcon =
  makeIcon FA.file_text_o

makeIcon : (Color -> Int -> Html msg) -> Html msg
makeIcon icon =
  span
    [ class "icon"]
    [ icon darkGrey 16 ]

-- Utils
(=>) = (,)

(</>) : String -> String -> String
(</>) directory file =
  if String.endsWith "/" directory then
    directory ++ file

  else
    directory ++ "/" ++ file
