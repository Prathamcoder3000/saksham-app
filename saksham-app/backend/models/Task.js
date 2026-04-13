const mongoose = require('mongoose');

const TaskSchema = new mongoose.Schema({
  title: {
    type: String,
    required: [true, 'Please add a title']
  },
  time: String,
  section: String,
  resident: {
    type: mongoose.Schema.ObjectId,
    ref: 'Resident'
  },
  caretaker: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true
  },
  status: {
    type: String,
    enum: ['done', 'progress', 'upcoming'],
    default: 'upcoming'
  },
  date: {
    type: String,
    required: true // YYYY-MM-DD
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Task', TaskSchema);
