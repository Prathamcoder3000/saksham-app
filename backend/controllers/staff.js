const Staff = require('../models/Staff');
const User = require('../models/User');

// @desc    Get all staff
// @route   GET /api/v1/staff
// @access  Private (Admin)
exports.getStaffList = async (req, res, next) => {
  try {
    const staff = await Staff.find().populate('user', 'name email role');
    res.status(200).json({ success: true, count: staff.length, data: staff });
  } catch (err) {
    next(err);
  }
};

// @desc    Get staff stats
// @route   GET /api/v1/staff/stats
// @access  Private (Admin)
exports.getStaffStats = async (req, res, next) => {
  try {
    const totalStaff = await Staff.countDocuments();
    const activeStaff = await Staff.countDocuments({ status: 'Active' });
    const onLeaveStaff = await Staff.countDocuments({ status: 'On Leave' });
    
    // Mocking "new applications" for now
    res.status(200).json({ 
      success: true, 
      data: {
        total: totalStaff,
        active: activeStaff,
        onLeave: onLeaveStaff,
        newApplications: 4 
      }
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single staff member
// @route   GET /api/v1/staff/:id
// @access  Private (Admin)
exports.getStaffMember = async (req, res, next) => {
  try {
    const staff = await Staff.findById(req.params.id).populate('user', 'name email role');
    if (!staff) {
      return res.status(404).json({ success: false, message: 'Staff member not found' });
    }
    res.status(200).json({ success: true, data: staff });
  } catch (err) {
    next(err);
  }
};

// @desc    Get staff schedule
// @route   GET /api/v1/staff/:id/schedule
// @access  Private (Admin, Caretaker own)
exports.getStaffSchedule = async (req, res, next) => {
  try {
    const staff = await Staff.findById(req.params.id);
    if (!staff) {
      return res.status(404).json({ success: false, message: 'Staff member not found' });
    }
    
    // Authorization check: Admin or the caretaker themselves
    if (req.user.role !== 'Admin' && staff.user.toString() !== req.user.id) {
        return res.status(403).json({ success: false, message: 'Not authorized to view this schedule' });
    }

    res.status(200).json({ success: true, data: staff.schedule });
  } catch (err) {
    next(err);
  }
};

// @desc    Add new staff member
// @route   POST /api/v1/staff
// @access  Private (Admin)
exports.addStaff = async (req, res, next) => {
  try {
    let userId = req.body.user;

    // If user data (email/password) is provided instead of an ID, create the User first
    if (!userId && req.body.email) {
        const user = await User.create({
            name: req.body.name || 'New Staff',
            email: req.body.email,
            password: req.body.password || 'Saksham@123', // System Default
            role: req.body.role || 'Caretaker'
        });
        userId = user._id;
    }

    if (!userId) {
        return res.status(400).json({ success: false, message: 'Please provide a valid user ID or user details (email, password)' });
    }

    req.body.user = userId;
    const staff = await Staff.create(req.body);
    
    res.status(201).json({ success: true, data: staff });
  } catch (err) {
    next(err);
  }
};

// @desc    Update staff member
// @route   PUT /api/v1/staff/:id
// @access  Private (Admin)
exports.updateStaff = async (req, res, next) => {
  try {
    let staff = await Staff.findById(req.params.id);
    if (!staff) {
      return res.status(404).json({ success: false, message: 'Staff member not found' });
    }

    // Update associated User details if provided
    if (req.body.name || req.body.email || req.body.role || req.body.phone) {
      const userUpdate = {};
      if (req.body.name) userUpdate.name = req.body.name;
      if (req.body.email) userUpdate.email = req.body.email;
      if (req.body.role) userUpdate.role = req.body.role;
      if (req.body.phone) userUpdate.phone = req.body.phone;

      await User.findByIdAndUpdate(staff.user, userUpdate, {
        runValidators: true
      });
    }

    // Update Staff record
    staff = await Staff.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    }).populate('user', 'name email role phone');

    res.status(200).json({ success: true, data: staff });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete staff member
// @route   DELETE /api/v1/staff/:id
// @access  Private (Admin)
exports.deleteStaff = async (req, res, next) => {
  try {
    const staff = await Staff.findById(req.params.id);
    if (!staff) {
      return res.status(404).json({ success: false, message: 'Staff member not found' });
    }

    // 🛡️ SAFETY CHECK: Prevent self-deletion
    if (staff.user.toString() === req.user.id) {
      return res.status(400).json({ 
        success: false, 
        message: 'Security Violation: You cannot delete your own administrative account while logged in.' 
      });
    }

    // Delete associated User account
    await User.findByIdAndDelete(staff.user);
    
    // Delete Staff record
    await staff.deleteOne();
    
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
