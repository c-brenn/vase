port module Socket exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (field, string, at, list, andThen)
import Messages    exposing (Msg(..), Diff)
import Models      exposing (File, Directory)
import Set         exposing (Set(..))

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
        (at ["directories"] set)
        (at ["files"] set)
    "presence_diff" ->
      JD.map PresenceDiff
        ( JD.map4 Diff
           (at ["additions", "directories"] set)
           (at ["additions", "files"] set)
           (at ["deletions", "directories"] set)
           (at ["deletions", "files"] set)
        )

    _ -> JD.succeed NoOp

set : JD.Decoder (Set String)
set =
  JD.map Set.fromList (list string)
