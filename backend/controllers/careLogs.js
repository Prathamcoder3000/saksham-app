const CareLog = require('../models/CareLog');

// @desc    Get recent care activity feed
// @route   GET /api/v1/care-logs
// @access  Private (Admin, Family)
exports.getCareLogs = async (req, res, next) => {
  try {
    const filter = {};
    if (req.query.residentId) filter.resident = req.query.residentId;
    
    // In family flow, we'd typically restrict to their resident
    
    const logs = await CareLog.find(filter)
        .populate('resident', 'name room')
        .populate('caretaker', 'name')
        .sort('-timestamp')
        .limit(20);

    res.status(200).json({ success: true, count: logs.length, data: logs });
  } catch (err) {
    next(err);
  }
};

// @desc    Submit care action log
// @route   POST /api/v1/care-logs
// @access  Private (Caretaker)
exports.createCareLog = async (req, res, next) => {
  try {
    req.body.caretaker = req.user.id;
    const log = await CareLog.create(req.body);
    res.status(201).json({ success: true, data: log });
  } catch (err) {
    next(err);
  }
};
