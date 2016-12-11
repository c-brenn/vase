import "phoenix_html"
import {Socket} from "phoenix"

const elmDiv = document.getElementById('elm-container')
const elmApp = Elm.Main.embed(elmDiv);

let socket = new Socket("/socket")
socket.connect()

let channel = {leave: () => {}}

elmApp.ports.cd.subscribe(directory => {
  channel.leave()
  channel = socket.channel(`directories:${directory}`, {})
  initializeChannel(channel)
})

let initializeChannel = channel => {
  channel.on("ls", dir_contents => {
    console.log `received contents: ${dir_contents}`
    elmApp.ports.rawDirectoryEvents.send(
      {
        event: 'ls',
        directories: dir_contents.directories,
        files: dir_contents.files
      }
    )
  })


  channel.on("presence_diff", diff => {
    console.log `Received diff: ${diff}`
  })

  channel.join()
}


