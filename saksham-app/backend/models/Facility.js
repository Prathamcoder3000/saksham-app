const mongoose = require('mongoose');

const FacilitySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true
  },
  address: String,
  branches: [String],
  permissions: {
    type: Map,
    of: [String] // Role -> [Permissions]
  },
  auditLogs: [
    {
      action: String,
      admin: {
        type: mongoose.Schema.ObjectId,
        ref: 'User'
      },
      timestamp: {
        type: Date,
        default: Date.now
      }
    }
  ],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Facility', FacilitySchema);
