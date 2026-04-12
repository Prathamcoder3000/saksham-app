const express = require('express');
const {
  getSummary,
  getAdherenceTrend,
  getResidentReport
} = require('../controllers/reports');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);
router.use(authorize('Admin'));

router.get('/summary', getSummary);
router.get('/adherence-trend', getAdherenceTrend);
router.get('/resident/:id', getResidentReport);

module.exports = router;
