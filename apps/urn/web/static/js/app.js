import "phoenix_html"
import  {Socket} from "phoenix"


let socket = new Socket("/socket")
socket.connect()

let channel = socket.channel("directories:/", {})

channel.on("ls", dir_contents => {
  console.log `Received dir_contents: ${dir_contents}`
})

channel.on("presence_diff", diff => {
  console.log `Received diff: ${diff}`
})

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

