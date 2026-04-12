const Alert = require('../models/Alert');

// @desc    Trigger emergency SOS
// @route   POST /api/v1/alerts/sos
// @access  Private (Caretaker)
exports.triggerSOS = async (req, res, next) => {
  try {
    req.body.caretaker = req.user.id;
    const alert = await Alert.create(req.body);
    
    // TRIGGER: Notify all Admins
    const User = require('../models/User');
    const Notification = require('../models/Notification');
    
    const admins = await User.find({ role: 'Admin' });
    const caretaker = await User.findById(req.user.id);

    const notifications = admins.map(admin => ({
        user: admin._id,
        title: '🚨 EMERGENCY SOS',
        message: `${caretaker.name} triggered SOS at ${req.body.location || 'Unknown Location'}. Note: ${req.body.note || 'None'}`
    }));

    await Notification.insertMany(notifications);
    
    res.status(201).json({ success: true, data: alert });
  } catch (err) {
    next(err);
  }
};

// @desc    Get all alerts
// @route   GET /api/v1/alerts
// @access  Private (Admin)
exports.getAlerts = async (req, res, next) => {
  try {
    const alerts = await Alert.find().populate('caretaker', 'name').sort('-timestamp');
    res.status(200).json({ success: true, count: alerts.length, data: alerts });
  } catch (err) {
    next(err);
  }
};

// @desc    Resolve alert
// @route   PATCH /api/v1/alerts/:id/resolve
// @access  Private (Admin)
exports.resolveAlert = async (req, res, next) => {
  try {
    const alert = await Alert.findByIdAndUpdate(req.params.id, {
      status: 'resolved',
      resolvedBy: req.user.id,
      resolvedAt: Date.now()
    }, {
      new: true,
      runValidators: true
    });

    if (!alert) {
      return res.status(404).json({ success: false, message: 'Alert not found' });
    }

    res.status(200).json({ success: true, data: alert });
  } catch (err) {
    next(err);
  }
};
