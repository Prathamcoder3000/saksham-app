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
    enum: ['pending', 'done', 'progress', 'upcoming'],
    default: 'pending'
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

TaskSchema.index({ caretaker: 1, date: 1 });
TaskSchema.index({ resident: 1 });

module.exports = mongoose.model('Task', TaskSchema);