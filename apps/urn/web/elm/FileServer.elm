module FileServer exposing (..)

import Http
import Task exposing (..)
import Json.Decode as JD exposing (at, string)
import Messages exposing (Msg(..))

whereIs : String -> String -> Task Http.Error String
whereIs host path =
  let
      url =
        "http://" ++ host ++ "/api/files/whereis" ++"?file=" ++ path
  in
      Http.get url whereIsDecoder
        |> Http.toTask

whereIsDecoder : JD.Decoder String
whereIsDecoder =
  JD.map2 (\host port_ -> "http://" ++ host ++ ":" ++ port_)
    (at ["host"] string)
    (at ["port"] string)


delete : String -> String -> Cmd Msg
delete host path =
  Task.attempt (\_ -> NoOp) <|
    (whereIs host path
      |> andThen (remoteDelete path))

remoteDelete : String -> String -> Task Http.Error String
remoteDelete path remote =
  let
      url =
        remote ++ "/api/files/delete" ++ "?file=" ++ path
  in
      Http.get url (JD.succeed "gr8")
        |> Http.toTask
