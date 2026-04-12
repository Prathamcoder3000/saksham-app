const express = require('express');
const {
  getFacility,
  updateFacility,
  getPermissions,
  updatePermissions,
  getAuditLogs
} = require('../controllers/facility');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);
router.use(authorize('Admin'));

router.route('/')
  .get(getFacility)
  .put(updateFacility);

router.route('/permissions')
  .get(getPermissions)
  .put(updatePermissions);

router.get('/audit-logs', getAuditLogs);

module.exports = router;
