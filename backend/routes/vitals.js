const express = require('express');
const {
  getLatestVitals,
  getVitalsHistory,
  logVitals
} = require('../controllers/vitals');

const router = express.Router({ mergeParams: true });

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router.route('/')
  .get(getLatestVitals)
  .post(authorize('Caretaker', 'Admin'), logVitals);

router.get('/history', getVitalsHistory);

module.exports = router;
