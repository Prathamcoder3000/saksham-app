const express = require('express');
const {
  getTasks,
  getResidentTasks,
  getTask,
  createTask,
  updateTask,
  updateTaskStatus,
  deleteTask
} = require('../controllers/tasks');

const router = express.Router({ mergeParams: true });

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router
  .route('/')
  .get(getTasks)
  .post(authorize('Caretaker', 'Admin'), createTask);

router.get('/resident', getResidentTasks); // When nested under resident: /residents/:id/tasks (via mergeParams)

router
  .route('/:id')
  .get(getTask)
  .put(updateTask)
  .delete(deleteTask);

router.patch('/:id/status', authorize('Caretaker'), updateTaskStatus);

module.exports = router;
