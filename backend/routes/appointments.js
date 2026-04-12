const express = require('express');
const {
  getAppointments,
  createAppointment,
  updateAppointment,
  deleteAppointment
} = require('../controllers/appointments');

const router = express.Router();

const { protect } = require('../middleware/auth');

router.use(protect);

router
  .route('/')
  .get(getAppointments)
  .post(createAppointment);

router
  .route('/:id')
  .put(updateAppointment)
  .delete(deleteAppointment);

module.exports = router;
