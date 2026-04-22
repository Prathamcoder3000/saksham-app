const mongoose = require('mongoose');

const AlertSchema = new mongoose.Schema({
  caretaker: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true
  },
  location: String,
  note: String,
  status: {
    type: String,
    enum: ['active', 'resolved'],
    default: 'active'
  },
  resolvedBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  },
  resolvedAt: Date,
  timestamp: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Alert', AlertSchema);
