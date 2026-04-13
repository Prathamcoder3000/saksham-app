const Resident = require('../models/Resident');

// @desc    Get all residents
// @route   GET /api/v1/residents
// @access  Private (Admin, Caretaker, Family)
exports.getResidents = async (req, res, next) => {
  try {
    let query;
    if (req.user.role === 'Family') {
      query = Resident.find({ family: req.user.id });
    } else {
      query = Resident.find();
    }
    
    const residents = await query.populate('assignedCaretaker', 'name email');
    res.status(200).json({ success: true, count: residents.length, data: residents });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single resident
// @route   GET /api/v1/residents/:id
// @access  Private
exports.getResident = async (req, res, next) => {
  try {
    const resident = await Resident.findById(req.params.id).populate('assignedCaretaker', 'name email');
    if (!resident) {
      return res.status(404).json({ success: false, message: 'Resident not found' });
    }
    res.status(200).json({ success: true, data: resident });
  } catch (err) {
    next(err);
  }
};

// @desc    Create resident
// @route   POST /api/v1/residents
// @access  Private (Admin)
exports.createResident = async (req, res, next) => {
  try {
    const resident = await Resident.create(req.body);
    res.status(201).json({ success: true, data: resident });
  } catch (err) {
    next(err);
  }
};

// @desc    Create resident (Caretaker flow)
// @route   POST /api/v1/caretaker/residents
// @access  Private (Caretaker)
exports.caretakerCreateResident = async (req, res, next) => {
    try {
      // Logic for caretaker limited field creation
      const resident = await Resident.create({
          ...req.body,
          assignedCaretaker: req.user.id
      });
      res.status(201).json({ success: true, data: resident });
    } catch (err) {
      next(err);
    }
  };

// @desc    Update resident
// @route   PUT /api/v1/residents/:id
// @access  Private (Admin)
exports.updateResident = async (req, res, next) => {
  try {
    const resident = await Resident.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
    if (!resident) {
      return res.status(404).json({ success: false, message: 'Resident not found' });
    }
    res.status(200).json({ success: true, data: resident });
  } catch (err) {
    next(err);
  }
};

// @desc    Update resident (Caretaker limited fields)
// @route   PUT /api/v1/caretaker/residents/:id
// @access  Private (Caretaker)
exports.caretakerUpdateResident = async (req, res, next) => {
    try {
      // Allowed fields for caretaker: name, age, conditions, allergies, emergencyContactName, emergencyContactPhone
      const allowedUpdates = ['name', 'age', 'conditions', 'allergies', 'emergencyContactName', 'emergencyContactPhone'];
      const updates = {};
      Object.keys(req.body).forEach(key => {
          if (allowedUpdates.includes(key)) updates[key] = req.body[key];
      });

      const resident = await Resident.findByIdAndUpdate(req.params.id, updates, {
        new: true,
        runValidators: true
      });
      if (!resident) {
        return res.status(404).json({ success: false, message: 'Resident not found' });
      }
      res.status(200).json({ success: true, data: resident });
    } catch (err) {
      next(err);
    }
  };

// @desc    Delete resident
// @route   DELETE /api/v1/residents/:id
// @access  Private (Admin)
exports.deleteResident = async (req, res, next) => {
  try {
    const resident = await Resident.findById(req.params.id);
    if (!resident) {
      return res.status(404).json({ success: false, message: 'Resident not found' });
    }
    await resident.deleteOne();
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
