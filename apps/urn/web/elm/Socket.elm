port module Socket exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (field, string, at, list, andThen)
import Messages    exposing (Msg(..))
import Models      exposing (File, Directory)

port cd : String -> Cmd msg

port rawDirectoryEvents : (JE.Value -> msg) -> Sub msg

directoryEvents : Sub Msg
directoryEvents = rawDirectoryEvents decodeEvent

decodeEvent : JE.Value -> Msg
decodeEvent event =
  case JD.decodeValue eventDecoder event of
    Ok msg -> msg
    _ -> NoOp


eventDecoder : JD.Decoder Msg
eventDecoder = field "event" string
                |> andThen eventInfo

eventInfo : String -> JD.Decoder Msg
eventInfo eventType =
  case eventType of
    "ls" ->
       JD.map2 DirectoryListing
        (at ["directories"] (list string))
        (at ["files"] (list string))
    _ -> JD.succeed NoOp
