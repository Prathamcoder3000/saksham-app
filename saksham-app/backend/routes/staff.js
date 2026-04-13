const express = require('express');
const {
  getStaffList,
  getStaffStats,
  getStaffMember,
  getStaffSchedule,
  addStaff,
  updateStaff,
  deleteStaff
} = require('../controllers/staff');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router.get('/stats', authorize('Admin'), getStaffStats);

router
  .route('/')
  .get(authorize('Admin'), getStaffList)
  .post(authorize('Admin'), addStaff);

router
  .route('/:id')
  .get(authorize('Admin'), getStaffMember)
  .put(authorize('Admin'), updateStaff)
  .delete(authorize('Admin'), deleteStaff);

router.get('/:id/schedule', getStaffSchedule);

module.exports = router;
