const express = require('express');
const {
  getMedicines,
  getTodayMedicines,
  addMedicine,
  updateMedicine,
  updateMedicineStatus,
  deleteMedicine
} = require('../controllers/medicines');

const router = express.Router({ mergeParams: true });

const { protect } = require('../middleware/auth');
const { authorize } = require('../middleware/roleGuard');

router.use(protect);

router
  .route('/')
  .get(getMedicines)
  .post(authorize('Caretaker', 'Admin'), addMedicine);

router.get('/today', getTodayMedicines);

router
  .route('/:id')
  .put(authorize('Caretaker', 'Admin'), updateMedicine)
  .delete(authorize('Caretaker', 'Admin'), deleteMedicine);

router.patch('/:id/status', authorize('Caretaker'), updateMedicineStatus);

module.exports = router;
