const Resident = require('../models/Resident');
const Medicine = require('../models/Medicine');
const Vitals = require('../models/Vitals');
const Staff = require('../models/Staff');
const Alert = require('../models/Alert');

// @desc    Get overall summary
// @route   GET /api/v1/reports/summary
// @access  Private (Admin)
exports.getSummary = async (req, res, next) => {
  try {
    // These would typically be complex aggregations
    // For now, providing indicative stats
    res.status(200).json({
      success: true,
      data: {
        adherenceRate: 85,
        activeAlerts: await Alert.countDocuments({ status: 'active' }),
        dailyCheckins: 142
      }
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get adherence trend
// @route   GET /api/v1/reports/adherence-trend
// @access  Private (Admin)
exports.getAdherenceTrend = async (req, res, next) => {
  try {
    // Mock data for the trend
    res.status(200).json({
      success: true,
      data: [
        { date: '2026-04-05', rate: 82 },
        { date: '2026-04-06', rate: 84 },
        { date: '2026-04-07', rate: 81 },
        { date: '2026-04-08', rate: 88 }
      ]
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get specific resident report
// @route   GET /api/v1/reports/resident/:id
// @access  Private (Admin)
exports.getResidentReport = async (req, res, next) => {
  try {
    const resident = await Resident.findById(req.params.id);
    const vitals = await Vitals.find({ resident: req.params.id }).sort('-recordedAt').limit(10);
    const meds = await Medicine.find({ resident: req.params.id });

    res.status(200).json({
      success: true,
      data: {
        resident,
        healthScore: 78,
        recentVitals: vitals,
        medicationAdherence: 92
      }
    });
  } catch (err) {
    next(err);
  }
};
