const express = require('express');
const {
  triggerSOS,
  getAlerts,
  resolveAlert
} = require('../controllers/alerts');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router.post('/sos', authorize('Caretaker', 'Admin'), triggerSOS);
router.get('/', authorize('Admin'), getAlerts);
router.patch('/:id/resolve', authorize('Admin'), resolveAlert);

module.exports = router;
