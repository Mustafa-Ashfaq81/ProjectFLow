const express = require('express');
const http = require('http');
const { Server } = require("socket.io");


const app = express();
const server = http.createServer(app);
const io = new Server(server);
const messages = [];

io.use((socket, next)=> {
    const username = socket.handshake.query.username
    const rooms_string = socket.handshake.query.rooms
    const rooms = rooms_string.split(',')
    // console.log("Middleware-checking",socket.handshake.query,username,rooms);
    if (username && username.length > 0 && rooms_string.length>0 &&rooms.length>0){ //username exists and belongs to atleast one group chat
        console.log("Middleware-check-passed");
        next();
    }
});

io.on('connection', (socket) => {
 
    const username = socket.handshake.query.username
    const rooms = socket.handshake.query.rooms.split(',')
    for (let i = 0; i < rooms.length; i++) {
        socket.join(rooms[i])
    }
    console.log("connected 2 socket & joined group chats",username,rooms,)

  socket.on('message', (data) => {
    console.log("got msg",data);
    const message = {
      message: data.message,
      sender: username,
      room: data.room,
      sentAt: Date.now()
    }
    messages.push(message)
    io.to(message.room).emit('message',message)
    // io.emit('message', message)
  })

  socket.on('disconnect', ()=> {
    console.log("Client disconnected: " + username);
  })
});

server.listen(3000, () => {
  console.log('listening on *:3000');
});