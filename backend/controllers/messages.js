const Message = require('../models/Message');

// @desc    Get messages in a conversation
// @route   GET /api/v1/messages/:conversationId
// @access  Private
exports.getMessages = async (req, res, next) => {
  try {
    const messages = await Message.find({ conversationId: req.params.conversationId }).sort('createdAt');
    res.status(200).json({ success: true, count: messages.length, data: messages });
  } catch (err) {
    next(err);
  }
};

// @desc    Send a message
// @route   POST /api/v1/messages
// @access  Private
exports.sendMessage = async (req, res, next) => {
  try {
    req.body.sender = req.user.id;
    // For simplicity, conversationId is passed in body
    const message = await Message.create(req.body);
    res.status(201).json({ success: true, data: message });
  } catch (err) {
    next(err);
  }
};
