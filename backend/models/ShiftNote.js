const mongoose = require('mongoose');

const ShiftNoteSchema = new mongoose.Schema({
  caretaker: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true
  },
  text: {
    type: String,
    required: true
  },
  color: String,
  date: {
    type: String, // YYYY-MM-DD
    required: true
  },
  timestamp: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('ShiftNote', ShiftNoteSchema);
