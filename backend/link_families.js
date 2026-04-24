const mongoose = require('mongoose');
const dotenv = require('dotenv');
const path = require('path');

dotenv.config();

const Resident = require('./models/Resident');
const User = require('./models/User');

const linkRemainingFamilies = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('MongoDB Connected...');

    // 1. family3@saksham.in (Suresh Iyer) -> Indubai
    const suresh = await User.findOne({ email: 'family3@saksham.in' });
    const indubai = await Resident.findOne({ name: 'Indubai' });

    if (suresh && indubai) {
      indubai.family = suresh._id;
      await indubai.save();
      console.log(`Linked Suresh Iyer to Indubai`);
    } else {
      console.log('Could not find Suresh or Indubai');
    }

    // 2. family6@saksham.in (Priya Menon) -> Sunita Singh
    const priya = await User.findOne({ email: 'family6@saksham.in' });
    const sunita = await Resident.findOne({ name: 'Sunita Singh' });

    if (priya && sunita) {
      sunita.family = priya._id;
      await sunita.save();
      console.log(`Linked Priya Menon to Sunita Singh`);
    } else {
      console.log('Could not find Priya or Sunita');
    }

    console.log('Linking complete!');
    process.exit();
  } catch (err) {
    console.error(err);
    process.exit(1);
  }
};

linkRemainingFamilies();
