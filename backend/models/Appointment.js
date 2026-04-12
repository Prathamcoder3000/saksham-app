const mongoose = require('mongoose');

const AppointmentSchema = new mongoose.Schema({
  resident: {
    type: mongoose.Schema.ObjectId,
    ref: 'Resident',
    required: true
  },
  title: {
    type: String,
    required: true
  },
  subtitle: String,
  type: {
    type: String,
    enum: ['medical', 'visit', 'other'],
    default: 'medical'
  },
  scheduledAt: {
    type: Date,
    required: true
  },
  conductedBy: String,
  status: {
    type: String,
    enum: ['pending', 'confirmed', 'cancelled', 'completed'],
    default: 'pending'
  },
  familyMember: {
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Appointment', AppointmentSchema);
