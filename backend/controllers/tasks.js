const Task = require('../models/Task');

// @desc    Get all tasks for current caretaker
// @route   GET /api/v1/tasks
// @access  Private (Caretaker)
exports.getTasks = async (req, res, next) => {
  try {
    const date = req.query.date || new Date().toISOString().split('T')[0];
    const tasks = await Task.find({ 
        caretaker: req.user.id,
        date: date
    }).populate('resident', 'name room');
    
    res.status(200).json({ success: true, count: tasks.length, data: tasks });
  } catch (err) {
    next(err);
  }
};

// @desc    Get all tasks for a specific resident
// @route   GET /api/v1/residents/:residentId/tasks
// @access  Private
exports.getResidentTasks = async (req, res, next) => {
    try {
      const tasks = await Task.find({ resident: req.params.residentId }).populate('caretaker', 'name');
      res.status(200).json({ success: true, count: tasks.length, data: tasks });
    } catch (err) {
      next(err);
    }
  };

// @desc    Get single task
// @route   GET /api/v1/tasks/:id
// @access  Private
exports.getTask = async (req, res, next) => {
  try {
    const task = await Task.findById(req.params.id).populate('resident', 'name room');
    if (!task) {
      return res.status(404).json({ success: false, message: 'Task not found' });
    }
    res.status(200).json({ success: true, data: task });
  } catch (err) {
    next(err);
  }
};

// @desc    Create task
// @route   POST /api/v1/tasks
// @access  Private (Caretaker, Admin)
exports.createTask = async (req, res, next) => {
  try {
    req.body.caretaker = req.user.id;
    if (!req.body.date) req.body.date = new Date().toISOString().split('T')[0];
    
    const task = await Task.create(req.body);
    res.status(201).json({ success: true, data: task });
  } catch (err) {
    next(err);
  }
};

// @desc    Update task
// @route   PUT /api/v1/tasks/:id
// @access  Private
exports.updateTask = async (req, res, next) => {
  try {
    const task = await Task.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true
    });
    if (!task) {
      return res.status(404).json({ success: false, message: 'Task not found' });
    }
    res.status(200).json({ success: true, data: task });
  } catch (err) {
    next(err);
  }
};

// @desc    Update task status
// @route   PATCH /api/v1/tasks/:id/status
// @access  Private (Caretaker)
exports.updateTaskStatus = async (req, res, next) => {
  try {
    const { status } = req.body;
    const task = await Task.findByIdAndUpdate(req.params.id, { status }, {
      new: true,
      runValidators: true
    }).populate('resident', 'name');

    if (!task) {
      return res.status(404).json({ success: false, message: 'Task not found' });
    }

    // TRIGGER: Auto-create CareLog if status is 'done' or 'completed'
    if (status === 'done' || status === 'completed') {
        const CareLog = require('../models/CareLog');
        await CareLog.create({
            resident: task.resident._id,
            type: 'other',  // 'activity' is not in schema enum — using 'other'
            title: `Task completed for ${task.resident.name}`,
            description: `${task.title} - ${task.description || ''}`,
            caretaker: req.user.id,
            timestamp: new Date()
        });
    }

    res.status(200).json({ success: true, data: task });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete task
// @route   DELETE /api/v1/tasks/:id
// @access  Private
exports.deleteTask = async (req, res, next) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    if (!task) {
      return res.status(404).json({ success: false, message: 'Task not found' });
    }
    res.status(200).json({ success: true, data: {} });
  } catch (err) {
    next(err);
  }
};
