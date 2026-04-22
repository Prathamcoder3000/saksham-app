const ShiftNote = require('../models/ShiftNote');

// @desc    Get shift notes for current caretaker
// @route   GET /api/v1/shift-notes
// @access  Private (Caretaker)
exports.getShiftNotes = async (req, res, next) => {
  try {
    const date = req.query.date || new Date().toISOString().split('T')[0];
    const notes = await ShiftNote.find({ caretaker: req.user.id, date });
    res.status(200).json({ success: true, count: notes.length, data: notes });
  } catch (err) {
    next(err);
  }
};

// @desc    Submit new shift note
// @route   POST /api/v1/shift-notes
// @access  Private (Caretaker)
exports.createShiftNote = async (req, res, next) => {
  try {
    req.body.caretaker = req.user.id;
    if (!req.body.date) req.body.date = new Date().toISOString().split('T')[0];
    
    const note = await ShiftNote.create(req.body);
    res.status(201).json({ success: true, data: note });
  } catch (err) {
    next(err);
  }
};

// @desc    Update shift note
// @route   PUT /api/v1/shift-notes/:id
// @access  Private (Caretaker)
exports.updateShiftNote = async (req, res, next) => {
  try {
    const note = await ShiftNote.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
    res.status(200).json({ success: true, data: note });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete shift note
// @route   DELETE /api/v1/shift-notes/:id
// @access  Private (Caretaker)
exports.deleteShiftNote = async (req, res, next) => {
  try {
    await ShiftNote.findByIdAndDelete(req.params.id);
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
