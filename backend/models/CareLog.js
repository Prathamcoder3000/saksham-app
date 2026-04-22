const mongoose = require('mongoose');

const CareLogSchema = new mongoose.Schema({
  resident: {
    type: mongoose.Schema.ObjectId,
    ref: 'Resident',
    required: true
  },
  type: {
    type: String,
    enum: ['medication', 'vitals', 'meal', 'walk', 'health check', 'other'],
    required: true
  },
  title: String,
  description: String,
  caretaker: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true
  },
  photoUrl: String,
  timestamp: {
    type: Date,
    default: Date.now
  }
});

CareLogSchema.index({ resident: 1, timestamp: -1 });

module.exports = mongoose.model('CareLog', CareLogSchema);
