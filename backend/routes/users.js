const express = require('express');
const {
  getMe,
  updateUserProfile,
  updatePassword,
  getUsers,
  updateUser,
  deleteUser
} = require('../controllers/users');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router.route('/')
  .get(authorize('Admin'), getUsers);

router.route('/:id')
  .put(authorize('Admin'), updateUser)
  .delete(authorize('Admin'), deleteUser);

router.get('/me', getMe);
router.put('/me', updateUserProfile);
router.put('/me/password', updatePassword);

module.exports = router;
