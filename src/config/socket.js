const { Server } = require('socket.io');

let io;

function initSocket(httpServer) {
  io = new Server(httpServer, {
    cors: {
      origin: '*',
      methods: ['GET', 'POST'],
    },
  });

  io.on('connection', (socket) => {
    console.log(`[Socket.IO] Client connected: ${socket.id}`);

    socket.on('terminal:register', (data) => {
      if (data && data.terminalId) {
        socket.join(`terminal:${data.terminalId}`);
        socket.terminalId = data.terminalId;
        console.log(`[Socket.IO] Terminal registered: ${data.terminalId}`);
      }
    });

    // Relay display:update to all other clients in the same terminal room
    socket.on('display:update', (data) => {
      if (socket.terminalId) {
        socket.to(`terminal:${socket.terminalId}`).emit('display:update', data);
      }
    });

    socket.on('disconnect', () => {
      console.log(`[Socket.IO] Client disconnected: ${socket.id}`);
    });
  });

  return io;
}

function getIO() {
  if (!io) throw new Error('Socket.IO not initialized');
  return io;
}

module.exports = { initSocket, getIO };
