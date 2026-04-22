const Vitals = require('../models/Vitals');

// @desc    Get latest vitals for a resident
// @route   GET /api/v1/residents/:residentId/vitals
// @access  Private
exports.getLatestVitals = async (req, res, next) => {
  try {
    const vitals = await Vitals.findOne({ resident: req.params.residentId }).sort('-recordedAt');
    res.status(200).json({ success: true, data: vitals });
  } catch (err) {
    next(err);
  }
};

// @desc    Get vitals history
// @route   GET /api/v1/residents/:residentId/vitals/history
// @access  Private
exports.getVitalsHistory = async (req, res, next) => {
  try {
    const vitals = await Vitals.find({ resident: req.params.residentId }).sort('-recordedAt').limit(20);
    res.status(200).json({ success: true, count: vitals.length, data: vitals });
  } catch (err) {
    next(err);
  }
};

// @desc    Log new vitals
// @route   POST /api/v1/residents/:residentId/vitals
// @access  Private (Caretaker)
exports.logVitals = async (req, res, next) => {
  try {
    req.body.resident = req.params.residentId;
    req.body.recordedBy = req.user.id;
    
    const vitals = await Vitals.create(req.body);

    // TRIGGER: Auto-create CareLog for vitals log
    const CareLog = require('../models/CareLog');
    const Resident = require('../models/Resident');
    const resident = await Resident.findById(req.params.residentId);

    await CareLog.create({
        resident: req.params.residentId,
        type: 'vitals',
        title: `Vitals recorded for ${resident.name}`,
        description: `Heart Rate: ${vitals.heartRate} bpm, BP: ${vitals.bloodPressure}, SpO2: ${vitals.oxygenSaturation}%`,
        caretaker: req.user.id,
        timestamp: new Date()
    });

    res.status(201).json({ success: true, data: vitals });
  } catch (err) {
    next(err);
  }
};
