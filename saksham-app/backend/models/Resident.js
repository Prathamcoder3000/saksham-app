const mongoose = require('mongoose');

const ResidentSchema = new mongoose.Schema({
  name: {
    type: String,
    required: [true, 'Please add a name']
  },
  age: Number,
  dob: Date,
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other']
  },
  room: String,
  status: {
    type: String,
    enum: ['Stable', 'Critical', 'Observing'],
    default: 'Stable'
  },
  conditions: [String],
  allergies: [String],
  admissionDate: {
    type: Date,
    default: Date.now
  },
  emergencyContactName: String,
  emergencyContactPhone: String,
  assignedCaretaker: {
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  },
  family: {
    type: mongoose.Schema.ObjectId,
    ref: 'User'
  },
  photoUrl: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Cascade delete medicines and tasks when a resident is deleted
ResidentSchema.pre('deleteOne', { document: true, query: false }, async function(next) {
    console.log(`Cleaning up data for resident ${this._id}`);
    await this.model('Medicine').deleteMany({ resident: this._id });
    await this.model('Task').deleteMany({ resident: this._id });
    await this.model('CareLog').deleteMany({ resident: this._id });
    await this.model('Appointment').deleteMany({ resident: this._id });
    await this.model('Vitals').deleteMany({ resident: this._id });
    next();
});

module.exports = mongoose.model('Resident', ResidentSchema);
