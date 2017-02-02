module Util exposing (..)

(</>) : String -> String -> String
(</>) directory file =
  if String.endsWith "/" directory then
    directory ++ file

  else
    directory ++ "/" ++ file
