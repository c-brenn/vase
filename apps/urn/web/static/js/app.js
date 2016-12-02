// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"
import  {Socket, Presence} from "phoenix"


let socket = new Socket("/socket")
socket.connect()

let fileList = document.getElementById("file-list")
let listBy = (file_name, {metas: metas}) => {
  return file_name
}
let render = (presences) => {
  fileList.innerHTML = Presence.list(presences, listBy)
    .map(file_name => `<li>${file_name}</li>`)
    .join("")
}

let presences = {}

let channel = socket.channel("file_events", {})

channel.on("presence_state", state => {
  presences = Presence.syncState(presences, state)
  render(presences)
})

channel.on("presence_diff", diff => {
  presences = Presence.syncDiff(presences, diff)
  render(presences)
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

