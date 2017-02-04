port module FileServer exposing (..)

import Http
import Task exposing (..)
import Json.Decode as JD exposing (at, string)
import Messages exposing (Msg(..))


type alias Host = String
type alias Endpoint = String
type alias Params = String
type alias Token = String


delete : Token -> String -> String -> Cmd Msg
delete token host path =
  let
      url =
        remoteUrl host "/api/files/delete" ("?file=" ++ path) token
  in
      Task.attempt (\_ -> NoOp) <|
        (Http.get url (JD.succeed "gr8")
        |> Http.toTask)

upload : String -> String -> Cmd Msg
upload host path =
  Task.attempt (\_ -> Submit host path) (Task.succeed 1)


port submitUploadForm :  (String, String) -> Cmd msg

remoteUrl : Host -> Endpoint -> Params -> Token -> String
remoteUrl host endpoint params token =
  let
      url = "http://" ++ host ++ endpoint
  in
      url ++ params ++ "&token=" ++ token
