import "phoenix_html"
import {Socket} from "phoenix"

const token = document.querySelector('meta[name="urn_token"]').content

const elmDiv = document.getElementById('elm-container')
const elmApp = Elm.Main.embed(elmDiv, {token: token});

let socket = new Socket("/socket", {params: {token: token}})
socket.connect()

let channel = {leave: () => {}}

elmApp.ports.cd.subscribe(directory => {
  channel.leave()
  channel = socket.channel(`directories:${directory}`, {})
  initializeChannel(channel)
})

elmApp.ports.submitUploadForm.subscribe(([host, path]) => {
  let form = document.getElementById('file-upload')
  let file = document.getElementById('file-upload-input').files[0]

  var formData = new FormData(form)

  formData.append("upload", file)
  formData.append("path", path)

  var request = new XMLHttpRequest();
  request.open("POST", `${host}/api/files/create`, true);
  request.setRequestHeader("Authentication", token)
  request.send(formData);
})

let initializeChannel = channel => {
  channel.on("ls", dir_contents => {
    elmApp.ports.rawDirectoryEvents.send(
      {
        event: 'ls',
        directories: dir_contents.directories,
        files: dir_contents.files
      }
    )
  })


  channel.on("presence_diff", diff => {
    elmApp.ports.rawDirectoryEvents.send(
      {
        event: 'presence_diff',
        additions: diff.additions,
        deletions: diff.deletions
      }
    )
  })

  channel.join()
}


