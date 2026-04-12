const Facility = require('../models/Facility');

// @desc    Get facility details
// @route   GET /api/v1/facility
// @access  Private (Admin)
exports.getFacility = async (req, res, next) => {
  try {
    const facility = await Facility.findOne(); // Assumes single facility record for now
    res.status(200).json({ success: true, data: facility });
  } catch (err) {
    next(err);
  }
};

// @desc    Update facility details
// @route   PUT /api/v1/facility
// @access  Private (Admin)
exports.updateFacility = async (req, res, next) => {
  try {
    let facility = await Facility.findOne();
    if (!facility) {
        facility = await Facility.create(req.body);
    } else {
        facility = await Facility.findOneAndUpdate({}, req.body, { new: true });
    }
    res.status(200).json({ success: true, data: facility });
  } catch (err) {
    next(err);
  }
};

// @desc    Get role permissions
// @route   GET /api/v1/facility/permissions
// @access  Private (Admin)
exports.getPermissions = async (req, res, next) => {
  try {
    const facility = await Facility.findOne();
    res.status(200).json({ success: true, data: facility ? facility.permissions : {} });
  } catch (err) {
    next(err);
  }
};

// @desc    Update role permissions
// @route   PUT /api/v1/facility/permissions
// @access  Private (Admin)
exports.updatePermissions = async (req, res, next) => {
    try {
      const facility = await Facility.findOneAndUpdate({}, { permissions: req.body }, { new: true });
      res.status(200).json({ success: true, data: facility.permissions });
    } catch (err) {
      next(err);
    }
  };
    
// @desc    Get audit logs
// @route   GET /api/v1/facility/audit-logs
// @access  Private (Admin)
exports.getAuditLogs = async (req, res, next) => {
  try {
    const facility = await Facility.findOne().populate('auditLogs.admin', 'name');
    res.status(200).json({ success: true, data: facility ? facility.auditLogs : [] });
  } catch (err) {
    next(err);
  }
};
