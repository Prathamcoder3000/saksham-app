const mongoose = require('mongoose');

const VitalsSchema = new mongoose.Schema({
  resident: {
    type: mongoose.Schema.ObjectId,
    ref: 'Resident',
    required: true
  },
  heartRate: Number,
  heartRateTrend: String,
  bloodPressure: String, // e.g., "120/80"
  sleepHours: Number,
  sleepTrend: String,
  stepsToday: Number,
  oxygenSaturation: Number,
  glucoseLevel: Number,
  recordedBy: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true
  },
  recordedAt: {
    type: Date,
    default: Date.now
  }
});

VitalsSchema.index({ resident: 1, recordedAt: -1 });

module.exports = mongoose.model('Vitals', VitalsSchema);
