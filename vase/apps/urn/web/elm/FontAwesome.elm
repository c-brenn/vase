module FontAwesome exposing (..)

import Color exposing (Color, toRgb, darkGrey)
import Html exposing (Html)
import Html.Attributes exposing (class)
import Svg exposing (..)
import Svg.Attributes exposing (width, height, viewBox, d, fill)


makeIcon : (Color -> Int -> Html msg) -> Html msg
makeIcon icon =
  Html.span
    [ class "icon"]
    [ icon darkGrey 16 ]

-- ICONS


home : Color -> Int -> Html msg
home =
  icon "M1472 992v480q0 26-19 45t-45 19h-384v-384h-256v384h-384q-26 0-45-19t-19-45v-480q0-1 .5-3t.5-3l575-474 575 474q1 2 1 6zm223-69l-62 74q-8 9-21 11h-3q-13 0-21-7l-692-577-692 577q-12 8-24 7-13-2-21-11l-62-74q-8-10-7-23.5t11-21.5l719-599q32-26 76-26t76 26l244 204v-195q0-14 9-23t23-9h192q14 0 23 9t9 23v408l219 182q10 8 11 21.5t-7 23.5z"


file_image_o : Color -> Int -> Html msg
file_image_o =
  icon "M1596 380q28 28 48 76t20 88v1152q0 40-28 68t-68 28h-1344q-40 0-68-28t-28-68v-1600q0-40 28-68t68-28h896q40 0 88 20t76 48zm-444-244v376h376q-10-29-22-41l-313-313q-12-12-41-22zm384 1528v-1024h-416q-40 0-68-28t-28-68v-416h-768v1536h1280zm-128-448v320h-1024v-192l192-192 128 128 384-384zm-832-192q-80 0-136-56t-56-136 56-136 136-56 136 56 56 136-56 136-136 56z"


file_text_o : Color -> Int -> Html msg
file_text_o =
  icon "M1596 380q28 28 48 76t20 88v1152q0 40-28 68t-68 28h-1344q-40 0-68-28t-28-68v-1600q0-40 28-68t68-28h896q40 0 88 20t76 48zm-444-244v376h376q-10-29-22-41l-313-313q-12-12-41-22zm384 1528v-1024h-416q-40 0-68-28t-28-68v-416h-768v1536h1280zm-1024-864q0-14 9-23t23-9h704q14 0 23 9t9 23v64q0 14-9 23t-23 9h-704q-14 0-23-9t-9-23v-64zm736 224q14 0 23 9t9 23v64q0 14-9 23t-23 9h-704q-14 0-23-9t-9-23v-64q0-14 9-23t23-9h704zm0 256q14 0 23 9t9 23v64q0 14-9 23t-23 9h-704q-14 0-23-9t-9-23v-64q0-14 9-23t23-9h704z"


folder : Color -> Int -> Html msg
folder =
  icon "M1728 608v704q0 92-66 158t-158 66h-1216q-92 0-158-66t-66-158v-960q0-92 66-158t158-66h320q92 0 158 66t66 158v32h672q92 0 158 66t66 158z"

download : Color -> Int -> Html msg
download =
  rotatedIcon "M1280 192q0 26 -19 45t-45 19t-45 -19t-19 -45t19 -45t45 -19t45 19t19 45zM1536 192q0 26 -19 45t-45 19t-45 -19t-19 -45t19 -45t45 -19t45 19t19 45zM1664 416v-320q0 -40 -28 -68t-68 -28h-1472q-40 0 -68 28t-28 68v320q0 40 28 68t68 28h465l135 -136 q58 -56 136 -56t136 56l136 136h464q40 0 68 -28t28 -68zM1339 985q17 -41 -14 -70l-448 -448q-18 -19 -45 -19t-45 19l-448 448q-31 29 -14 70q17 39 59 39h256v448q0 26 19 45t45 19h256q26 0 45 -19t19 -45v-448h256q42 0 59 -39z"

delete : Color -> Int -> Html msg
delete =
  scaledIcon "M1216 576v128q0 26 -19 45t-45 19h-768q-26 0 -45 -19t-19 -45v-128q0 -26 19 -45t45 -19h768q26 0 45 19t19 45zM1536 640q0 -209 -103 -385.5t-279.5 -279.5t-385.5 -103t-385.5 103t-279.5 279.5t-103 385.5t103 385.5t279.5 279.5t385.5 103t385.5 -103t279.5 -279.5 t103 -385.5z"


-- HELPERS

icon : String -> Color -> Int -> Html msg
icon pathString color size =
  let
    sizeString =
      toString size
  in
    svg
      [ width sizeString
      , height sizeString
      , viewBox "0 0 1792 1792"
      ]
      [ path [ fill (fromColor color), d pathString ] []
      ]

rotatedIcon : String -> Color -> Int -> Html msg
rotatedIcon pathString color size =
  let
    sizeString =
      toString size
  in
    svg
      [ width sizeString
      , height sizeString
      , viewBox "0 0 1792 1792"
      ]
      [ path [ fill (fromColor color), d pathString, Svg.Attributes.transform("rotate(180, 896, 896)")] []
      ]

scaledIcon : String -> Color -> Int -> Html msg
scaledIcon pathString color size =
  let
    sizeString =
      toString size
  in
    svg
      [ width sizeString
      , height sizeString
      , viewBox "0 0 1792 1792"
      ]
      [ path [ fill (fromColor color), d pathString, Svg.Attributes.transform("translate(288, 288)")] []
      ]

fromColor : Color -> String
fromColor color =
  let
    c = toRgb color
    r = toString c.red
    g = toString c.green
    b = toString c.blue
    a = toString c.alpha
  in
    "rgba(" ++ r ++ "," ++ g ++ "," ++ b ++ "," ++ a ++ ")"
