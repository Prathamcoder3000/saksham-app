const express = require('express');
const {
  getMe,
  updateUserProfile,
  updatePassword
} = require('../controllers/users');

const router = express.Router();

const { protect } = require('../middleware/auth');

router.use(protect);

router.get('/me', getMe);
router.put('/me', updateUserProfile);
router.put('/me/password', updatePassword);

module.exports = router;
