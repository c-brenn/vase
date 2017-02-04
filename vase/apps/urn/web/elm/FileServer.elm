port module FileServer exposing (..)

import Http
import Task exposing (..)
import Json.Decode as JD exposing (at, string)
import Messages exposing (Msg(..))

type alias Token = String

get : Token -> String -> JD.Decoder value -> Http.Request value
get token url decoder =
  Http.request
    { method = "GET"
    , headers = [Http.header "Authentication" token]
    , url = url
    , body = Http.emptyBody
    , expect = Http.expectJson decoder
    , timeout = Nothing
    , withCredentials = False
    }

whereIs : Token -> String -> String -> Task Http.Error String
whereIs token host path =
  let
      url =
        "http://" ++ host ++ "/api/files/whereis" ++"?file=" ++ path
  in
      get token url whereIsDecoder
        |> Http.toTask

whereIsDecoder : JD.Decoder String
whereIsDecoder =
  JD.map2 (\host port_ -> "http://" ++ host ++ ":" ++ port_)
    (at ["host"] string)
    (at ["port"] string)


delete : Token -> String -> String -> Cmd Msg
delete token host path =
  Task.attempt (\_ -> NoOp) <|
    (whereIs token host path
      |> andThen (remoteDelete token path))

remoteDelete : Token -> String -> String -> Task Http.Error String
remoteDelete token path remote =
  let
      url =
        remote ++ "/api/files/delete" ++ "?file=" ++ path
  in
      get token url (JD.succeed "gr8")
        |> Http.toTask

upload : Token -> String -> String -> Cmd Msg
upload token host path =
  let
      resultDecoder result =
        case result of
          Ok remote ->
            Submit remote path
          _ -> NoOp
  in
      Task.attempt resultDecoder (whereIs token host path)


port submitUploadForm :  (String, String) -> Cmd msg

