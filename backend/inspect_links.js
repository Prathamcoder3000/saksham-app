const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config();

const User = require('./models/User');
const Resident = require('./models/Resident');

const inspectData = async () => {
  try {
    if (!process.env.MONGO_URI) {
      console.error('MONGO_URI is not defined in .env');
      process.exit(1);
    }
    
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB Connected...');

    const familyUsers = await User.find({ role: 'Family' });
    console.log(`Found ${familyUsers.length} Family Users:`);
    familyUsers.forEach(u => console.log(`- ID: ${u._id}, Name: ${u.name}, Email: ${u.email}`));

    const residents = await Resident.find();
    console.log(`\nFound ${residents.length} Residents:`);
    residents.forEach(r => console.log(`- ID: ${r._id}, Name: ${r.name}, Family Link: ${r.family || 'None'}`));

    const linkedResidents = await Resident.find({ family: { $exists: true, $ne: null } }).populate('family');
    console.log(`\nLinked Residents (${linkedResidents.length}):`);
    linkedResidents.forEach(r => {
      if (r.family) {
        console.log(`- Resident: ${r.name} -> Family Member: ${r.family.name} (${r.family.email})`);
      } else {
        console.log(`- Resident: ${r.name} -> Broken Family Link ID: ${r.family}`);
      }
    });

    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

inspectData();
