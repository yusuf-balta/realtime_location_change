const express = require("express");
const { createServer } = require("http");
const { Server } = require("socket.io");

const app = express();
const httpServer = createServer(app);
const port = process.env.PORT || 8000

const io = new Server(httpServer, {
      "transports": ["websocket"],
      "autoConnect": true,
      "path": '/socket.io-client'
});

io.on("connection", (socket) => {
      console.log(socket.id)

      socket.on("position-change", (data) => {
            console.log(data);
            io.emit("position-change", data);
      })

});





httpServer.listen(port, () => { },);