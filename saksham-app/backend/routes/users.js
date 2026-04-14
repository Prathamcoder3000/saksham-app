const express = require('express');
const {
  getMe,
  updateUserProfile,
  updatePassword,
  getUsers
} = require('../controllers/users');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router.route('/')
  .get(authorize('Admin'), getUsers);

router.get('/me', getMe);
router.put('/me', updateUserProfile);
router.put('/me/password', updatePassword);

module.exports = router;
