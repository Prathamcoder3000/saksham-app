const express = require('express');
const multer = require('multer');
const path = require('path');

const router = express.Router();

const { protect } = require('../middleware/auth');

// Storage configuration
const storage = multer.diskStorage({
  destination: function(req, file, cb) {
    cb(null, 'uploads/');
  },
  filename: function(req, file, cb) {
    cb(null, `${file.fieldname}-${Date.now()}${path.extname(file.originalname)}`);
  }
});

const upload = multer({ storage: storage });

router.use(protect);

// Upload resident photo
router.post('/resident-photo/:id', upload.single('photo'), async (req, res) => {
  if (!req.file) {
    return res.status(400).json({ success: false, message: 'Please upload a file' });
  }
  
  // In a real app, update the Resident record with the photo URL
  const Resident = require('../models/Resident');
  await Resident.findByIdAndUpdate(req.params.id, { photoUrl: `/uploads/${req.file.filename}` });

  res.status(200).json({
    success: true,
    photoUrl: `/uploads/${req.file.filename}`
  });
});

// Upload staff photo
router.post('/staff-photo/:id', upload.single('photo'), async (req, res) => {
    if (!req.file) {
      return res.status(400).json({ success: false, message: 'Please upload a file' });
    }
    
    const Staff = require('../models/Staff');
    await Staff.findByIdAndUpdate(req.params.id, { photoUrl: `/uploads/${req.file.filename}` });
  
    res.status(200).json({
      success: true,
      photoUrl: `/uploads/${req.file.filename}`
    });
  });

module.exports = router;
