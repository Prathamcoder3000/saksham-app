const express = require('express');
const {
  getShiftNotes,
  createShiftNote,
  updateShiftNote,
  deleteShiftNote
} = require('../controllers/shiftNotes');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);
router.use(authorize('Caretaker'));

router
  .route('/')
  .get(getShiftNotes)
  .post(createShiftNote);

router
  .route('/:id')
  .put(updateShiftNote)
  .delete(deleteShiftNote);

module.exports = router;
