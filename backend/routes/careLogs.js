const express = require('express');
const {
  getCareLogs,
  createCareLog
} = require('../controllers/careLogs');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router
  .route('/')
  .get(getCareLogs)
  .post(authorize('Caretaker'), createCareLog);

module.exports = router;
