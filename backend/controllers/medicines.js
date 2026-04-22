const Medicine = require('../models/Medicine');

// @desc    Get all medicines for a resident
// @route   GET /api/v1/residents/:residentId/medicines
// @access  Private
exports.getMedicines = async (req, res, next) => {
  try {
    const medicines = await Medicine.find({ resident: req.params.residentId });
    res.status(200).json({ success: true, count: medicines.length, data: medicines });
  } catch (err) {
    next(err);
  }
};

// @desc    Get today's medicines for a resident
// @route   GET /api/v1/residents/:residentId/medicines/today
// @access  Private
exports.getTodayMedicines = async (req, res, next) => {
  try {
    const today = new Date().toISOString().split('T')[0]; // YYYY-MM-DD
    
    // If residentId is in params (merged), filter by it, otherwise get all (for dashboard)
    const filter = req.params.residentId ? { resident: req.params.residentId } : {};
    const medicines = await Medicine.find(filter).populate('resident', 'name room');
    
    // Filter/Log logic: Find logs for today or return medicine with "pending" status for today
    const data = medicines.map(med => {
        const todayLog = med.logs.find(log => log.date === today);
        return {
            ...med.toObject(),
            currentStatus: todayLog ? todayLog.status : 'pending'
        };
    });

    res.status(200).json({ success: true, data });
  } catch (err) {
    next(err);
  }
};

// @desc    Add medicine
// @route   POST /api/v1/residents/:residentId/medicines
// @access  Private (Caretaker)
exports.addMedicine = async (req, res, next) => {
  try {
    // if residentId URL se aaye toh use karo
    // warna frontend body ka resident use karo
    req.body.resident = req.params.residentId || req.body.resident;

    const medicine = await Medicine.create(req.body);

    res.status(201).json({
      success: true,
      data: medicine
    });

  } catch (err) {
    next(err);
  }
};

// @desc    Update medicine
// @route   PUT /api/v1/residents/:residentId/medicines/:id
// @access  Private (Caretaker)
exports.updateMedicine = async (req, res, next) => {
  try {
    const medicine = await Medicine.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
    if (!medicine) {
      return res.status(404).json({ success: false, message: 'Medicine not found' });
    }
    res.status(200).json({ success: true, data: medicine });
  } catch (err) {
    next(err);
  }
};

// @desc    Update medicine status (taken/pending/missed)
// @route   PATCH /api/v1/residents/:residentId/medicines/:id/status
// @access  Private (Caretaker)
exports.updateMedicineStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const today = new Date().toISOString().split('T')[0];
    const time = new Date().toTimeString().split(' ')[0].substring(0, 5); // HH:MM

    const medicine = await Medicine.findById(req.params.id);
    if (!medicine) {
      return res.status(404).json({ success: false, message: 'Medicine not found' });
    }

    // Check if log for today exists
    const logIndex = medicine.logs.findIndex(log => log.date === today);
    if (logIndex !== -1) {
        medicine.logs[logIndex].status = status;
        medicine.logs[logIndex].recordedBy = req.user.id;
        medicine.logs[logIndex].time = time;
    } else {
        medicine.logs.push({
            date: today,
            time,
            status,
            recordedBy: req.user.id
        });
    }

    await medicine.save();

    // TRIGGER: Auto-create CareLog if status is 'taken'
    if (status === 'taken') {
        const CareLog = require('../models/CareLog');
        const Resident = require('../models/Resident');
        const resident = await Resident.findById(medicine.resident);
        
        await CareLog.create({
            resident: medicine.resident,
            type: 'medication',
            title: `Medication taken by ${resident.name}`,
            description: `${medicine.name} (${medicine.dosage}) - ${medicine.instructions}`,
            caretaker: req.user.id,
            timestamp: new Date()
        });
    }

    res.status(200).json({ success: true, data: medicine });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete medicine
// @route   DELETE /api/v1/residents/:residentId/medicines/:id
// @access  Private (Caretaker)
exports.deleteMedicine = async (req, res, next) => {
  try {
    const medicine = await Medicine.findByIdAndDelete(req.params.id);
    if (!medicine) {
      return res.status(404).json({ success: false, message: 'Medicine not found' });
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
