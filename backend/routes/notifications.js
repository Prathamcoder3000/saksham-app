const express = require('express');
const {
  getNotifications,
  markAsRead,
  readAll
} = require('../controllers/notifications');

const router = express.Router();

const { protect } = require('../middleware/auth');

router.use(protect);

router.get('/', getNotifications);
router.patch('/read-all', readAll);
router.patch('/:id/read', markAsRead);

module.exports = router;
