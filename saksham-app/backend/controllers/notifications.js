const Notification = require('../models/Notification');

// @desc    Get user notifications
// @route   GET /api/v1/notifications
// @access  Private
exports.getNotifications = async (req, res, next) => {
  try {
    const notifications = await Notification.find({ user: req.user.id }).sort('-createdAt');
    res.status(200).json({ success: true, count: notifications.length, data: notifications });
  } catch (err) {
    next(err);
  }
};

// @desc    Mark notification as read
// @route   PATCH /api/v1/notifications/:id/read
// @access  Private
exports.markAsRead = async (req, res, next) => {
  try {
    const notification = await Notification.findByIdAndUpdate(req.params.id, { isRead: true }, {
      new: true
    });
    res.status(200).json({ success: true, data: notification });
  } catch (err) {
    next(err);
  }
};

// @desc    Mark all as read
// @route   PATCH /api/v1/notifications/read-all
// @access  Private
exports.readAll = async (req, res, next) => {
  try {
    await Notification.updateMany({ user: req.user.id }, { isRead: true });
    res.status(200).json({ success: true, message: 'All marked as read' });
  } catch (err) {
    next(err);
  }
};
