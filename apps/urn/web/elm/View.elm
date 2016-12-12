module View exposing (..)

import Html            exposing (..)
import Html.Attributes exposing (..)
import Html.Events     exposing (onInput, onClick)
import Messages        exposing (Msg(..))
import Models          exposing (Model)
import Routing         exposing (Route)
import Color           exposing (Color, darkGrey)
import Util            exposing ((</>))
import FontAwesome     as FA
import Set


import File
import Directory

view : Model -> Html Msg
view model =
  let
      contents =
        if model.loading then
          spinner
        else
          div
            [ class "row" ]
            [ div [ class "col-sm-8" ] [ directoryListing model ]
            , div [ class "col-sm-4" ] [ inputs model ]
            ]
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
      header =
        div [ class "block box-header" ] [ text "File Navigation" ]
  in
      div
        [ class "box" ]
        (header
        :: directoriesView model
        ++ filesView model
        )

directoriesView : Model -> List (Html Msg)
directoriesView model =
    List.map (Directory.view model.cwd) (model.directories |> Set.toList)

filesView : Model -> List (Html Msg)
filesView model =
  List.map File.view (model.files |> Set.toList)

inputs : Model -> Html Msg
inputs model =
    div
      []
      [ newDirInput model
      , fileUploadForm model
      ]

newDirInput : Model -> Html Msg
newDirInput model =
  div
    [ class "input-group" ]
    [ input
        [ type_ "text", class "form-control", value model.directoryInput, onInput DirectoryName ]
        []
    , span
        [ class "input-group-btn" ]
        [ button [ class "btn btn-primary", onClick NewDirectory ] [ text "new folder" ] ]
    ]

fileUploadForm : Model -> Html Msg
fileUploadForm model =
  Html.form
    [ class "file-upload", method "post", action "/api/files/create", enctype "multipart/form-data"]
    [ input [ type_ "file", name "upload" ] []
    , input [ type_ "hidden", value model.cwd, name "path" ] []
    , button [ class "btn btn-primary", type_ "submit" ] [ text "upload" ]
    ]

