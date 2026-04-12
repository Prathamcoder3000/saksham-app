const mongoose = require('mongoose');

const MedicineSchema = new mongoose.Schema({
  resident: {
    type: mongoose.Schema.ObjectId,
    ref: 'Resident',
    required: true
  },
  name: {
    type: String,
    required: [true, 'Please add medicine name']
  },
  dosage: String,
  instructions: String,
  condition: String,
  scheduledTime: String, // e.g., "09:00"
  frequency: {
    type: String,
    default: 'daily'
  },
  logs: [
    {
      date: String, // YYYY-MM-DD
      time: String,
      status: {
        type: String,
        enum: ['taken', 'pending', 'missed'],
        default: 'pending'
      },
      recordedBy: {
        type: mongoose.Schema.ObjectId,
        ref: 'User'
      }
    }
  ],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Medicine', MedicineSchema);
