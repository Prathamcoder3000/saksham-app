require('dotenv').config();
const express = require('express');
const cors = require('cors');
const connectDB = require('./config/db');
const http = require('http');
const socketio = require('socket.io');

// Connect to database
connectDB();

const app = express();

// Configure CORS for production readiness
const corsOptions = {
  origin: process.env.NODE_ENV === 'production' && process.env.CLIENT_URL ? process.env.CLIENT_URL : '*',
  methods: 'GET,HEAD,PUT,PATCH,POST,DELETE',
  credentials: true,
  optionsSuccessStatus: 204
};
app.use(cors(corsOptions));
app.use(express.json());

// Basic route
app.get('/', (req, res) => {
  res.send('Saksham API is running...');
});

// Route imports
const authRoutes = require('./routes/auth');
const userRoutes = require('./routes/users');
const residentRoutes = require('./routes/residents');
const medicineRoutes = require('./routes/medicines');
const taskRoutes = require('./routes/tasks');
const staffRoutes = require('./routes/staff');
const reportRoutes = require('./routes/reports');
const vitalRoutes = require('./routes/vitals');
const alertRoutes = require('./routes/alerts');
const appointmentRoutes = require('./routes/appointments');
const notificationRoutes = require('./routes/notifications');
const careLogRoutes = require('./routes/careLogs');
const shiftNoteRoutes = require('./routes/shiftNotes');
const messageRoutes = require('./routes/messages');
const facilityRoutes = require('./routes/facility');
const uploadRoutes = require('./routes/upload');

// Mount routers
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/residents', residentRoutes);
app.use('/api/v1/medicines', medicineRoutes);
app.use('/api/v1/tasks', taskRoutes);
app.use('/api/v1/staff', staffRoutes);
app.use('/api/v1/reports', reportRoutes);
app.use('/api/v1/vitals', vitalRoutes);
app.use('/api/v1/alerts', alertRoutes);
app.use('/api/v1/appointments', appointmentRoutes);
app.use('/api/v1/notifications', notificationRoutes);
app.use('/api/v1/care-logs', careLogRoutes);
app.use('/api/v1/shift-notes', shiftNoteRoutes);
app.use('/api/v1/messages', messageRoutes);
app.use('/api/v1/facility', facilityRoutes);
app.use('/api/v1/upload', uploadRoutes);

// Static folder for uploads
const path = require('path');
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const errorHandler = require('./middleware/error');
app.use(errorHandler);

const PORT = process.env.PORT || 5000;

const server = http.createServer(app);
const io = socketio(server, {
  cors: {
    origin: process.env.NODE_ENV === 'production' && process.env.CLIENT_URL ? process.env.CLIENT_URL : '*',
    methods: ["GET", "POST"]
  }
});

// Socket.io connection logic
io.on('connection', (socket) => {
  console.log('New WebSocket connection');

  socket.on('join', ({ userId }) => {
    socket.join(userId);
    console.log(`User ${userId} joined their private room`);
  });

  socket.on('disconnect', () => {
    console.log('User disconnected');
  });
});

// Pass io to request object for use in controllers
app.set('io', io);

server.listen(PORT, () => {
  console.log(`Server running in ${process.env.NODE_ENV} mode on port ${PORT}`);
});
