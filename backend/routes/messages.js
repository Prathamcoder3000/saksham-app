const express = require('express');
const {
  getMessages,
  sendMessage
} = require('../controllers/messages');

const router = express.Router();

const { protect } = require('../middleware/auth');

router.use(protect);

router.post('/', sendMessage);
router.get('/:conversationId', getMessages);

module.exports = router;
