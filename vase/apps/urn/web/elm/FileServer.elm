port module FileServer exposing (..)

import Http
import Task exposing (..)
import Json.Decode as JD exposing (at, string)
import Messages exposing (Msg(..))

get : String -> JD.Decoder value -> Http.Request value
get url decoder =
  Http.request
    { method = "GET"
    , headers = [Http.header "Authentication" "secret"]
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

whereIs : String -> String -> Task Http.Error String
whereIs host path =
  let
      url =
        "http://" ++ host ++ "/api/files/whereis" ++"?file=" ++ path
  in
      get url whereIsDecoder
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
      get url (JD.succeed "gr8")
        |> Http.toTask

upload : String -> String -> Cmd Msg
upload host path =
  let
      resultDecoder result =
        case result of
          Ok remote ->
            Submit remote path
          _ -> NoOp
  in
      Task.attempt resultDecoder (whereIs host path)


port submitUploadForm :  (String, String) -> Cmd msg

