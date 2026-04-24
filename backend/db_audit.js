const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('./models/User');
const Resident = require('./models/Resident');
const Medicine = require('./models/Medicine');
const Vitals = require('./models/Vitals');
const Task = require('./models/Task');
const Appointment = require('./models/Appointment');
const CareLog = require('./models/CareLog');

dotenv.config({ path: './.env' });

const audit = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('--- DATABASE AUDIT START ---');

    const collections = [
      { name: 'Users', model: User },
      { name: 'Residents', model: Resident },
      { name: 'Medicines', model: Medicine },
      { name: 'Vitals', model: Vitals },
      { name: 'Tasks', model: Task },
      { name: 'Appointments', model: Appointment },
      { name: 'CareLogs', model: CareLog }
    ];

    const results = {};

    for (const col of collections) {
      const count = await col.model.countDocuments();
      const samples = await col.model.find().limit(3).lean();
      results[col.name] = { count, samples };
      console.log(`[${col.name}] Count: ${count}`);
    }

    // Check for duplicate residents (by name)
    const residentDuplicates = await Resident.aggregate([
      { $group: { _id: "$name", count: { $sum: 1 } } },
      { $match: { count: { $gt: 1 } } }
    ]);
    console.log('\n--- Duplicate Residents ---');
    console.log(residentDuplicates);

    // Check for residents without family
    const residentsWithoutFamily = await Resident.countDocuments({ family: { $exists: false } });
    const residentsWithoutCaretaker = await Resident.countDocuments({ assignedCaretaker: { $exists: false } });
    console.log(`\nResidents without Family: ${residentsWithoutFamily}`);
    console.log(`Residents without Caretaker: ${residentsWithoutCaretaker}`);

    // Check for Users with non-Indian names (heuristic: doesn't look like common Indian name or contains generic test words)
    const genericUsers = await User.find({ 
      $or: [
        { name: /test/i },
        { name: /admin/i },
        { name: /dummy/i },
        { name: /sample/i }
      ]
    }).select('name email role');
    console.log('\n--- Generic/Test Users ---');
    console.log(genericUsers);

    console.log('\n--- DATABASE AUDIT END ---');
    process.exit(0);
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

audit();
