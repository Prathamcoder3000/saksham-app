const express = require('express');
const {
  getResidents,
  getResident,
  createResident,
  caretakerCreateResident,
  updateResident,
  caretakerUpdateResident,
  deleteResident
} = require('../controllers/residents');

const router = express.Router();

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router
  .route('/')
  .get(authorize('Admin', 'Caretaker', 'Family'), getResidents)
  .post(authorize('Admin'), createResident);

router
  .route('/:id')
  .get(getResident)
  .put(authorize('Admin'), updateResident)
  .delete(authorize('Admin'), deleteResident);

// Caretaker scoped routes
router.post('/caretaker-add', authorize('Caretaker'), caretakerCreateResident);
router.put('/caretaker-edit/:id', authorize('Caretaker'), caretakerUpdateResident);

// Also expose under the documented caretaker path
router.put('/caretaker/:id', authorize('Caretaker'), caretakerUpdateResident);


module.exports = router;
