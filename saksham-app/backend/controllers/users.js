const User = require('../models/User');

// @desc    Get current user profile
// @route   GET /api/v1/users/me
// @access  Private
exports.getMe = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id);
    res.status(200).json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

// @desc    Update user profile
// @route   PUT /api/v1/users/me
// @access  Private
exports.updateUserProfile = async (req, res, next) => {
  try {
    const fieldsToUpdate = {
      name: req.body.name,
      email: req.body.email,
      phone: req.body.phone
    };

    const user = await User.findByIdAndUpdate(req.user.id, fieldsToUpdate, {
      new: true,
      runValidators: true
    });

    res.status(200).json({ success: true, data: user });
  } catch (err) {
    next(err);
  }
};

// @desc    Update password
// @route   PUT /api/v1/users/me/password
// @access  Private
exports.updatePassword = async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).select('+password');

    // Check current password
    if (!(await user.matchPassword(req.body.currentPassword))) {
      return res.status(401).json({ success: false, message: 'Current password is incorrect' });
    }

    user.password = req.body.newPassword;
    await user.save();

    res.status(200).json({ success: true, message: 'Password updated successfully' });
  } catch (err) {
    next(err);
  }
};

// @desc    Get all users (with filtering)
// @route   GET /api/v1/users
// @access  Private (Admin)
exports.getUsers = async (req, res, next) => {
  try {
    const query = {};
    if (req.query.role) {
      query.role = req.query.role;
    }

    const users = await User.find(query);
    res.status(200).json({ success: true, count: users.length, data: users });
  } catch (err) {
    next(err);
  }
};
