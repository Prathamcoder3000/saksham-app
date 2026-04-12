const mongoose = require('mongoose');

const StaffSchema = new mongoose.Schema({
  user: {
    type: mongoose.Schema.ObjectId,
    ref: 'User',
    required: true,
    unique: true
  },
  employeeId: String,
  designation: String,
  shift: String,
  status: {
    type: String,
    enum: ['Active', 'On Leave', 'Inactive'],
    default: 'Active'
  },
  performance: {
    type: Number,
    default: 100
  },
  joiningDate: Date,
  photoUrl: String,
  schedule: [
    {
      day: String,
      startTime: String,
      endTime: String
    }
  ],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Staff', StaffSchema);
