const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('./models/User');
const Staff = require('./models/Staff');
const Resident = require('./models/Resident');
const Medicine = require('./models/Medicine');
const CareLog = require('./models/CareLog');

dotenv.config();

const residents = [
  {
    name: 'Rajesh Kumar',
    age: 72,
    gender: 'Male',
    room: 'Room 101',
    status: 'Stable',
    conditions: ['Hypertension'],
    allergies: ['Peanuts'],
    emergencyContactName: 'Anita Kumar',
    emergencyContactPhone: '9876543210'
  },
  {
    name: 'Savita Devi',
    age: 68,
    gender: 'Female',
    room: 'Room 104',
    status: 'Stable',
    conditions: ['Diabetes'],
    allergies: [],
    emergencyContactName: 'Suresh Devi',
    emergencyContactPhone: '9876543211'
  },
  {
    name: 'Om Prakash',
    age: 75,
    gender: 'Male',
    room: 'Room 202',
    status: 'Stable',
    conditions: ['Arthritis'],
    allergies: ['Dust'],
    emergencyContactName: 'Sunil Prakash',
    emergencyContactPhone: '9876543212'
  },
  {
    name: 'Meera Bai',
    age: 70,
    gender: 'Female',
    room: 'Room 305',
    status: 'Stable',
    conditions: ['Dementia'],
    allergies: [],
    emergencyContactName: 'Karan Bai',
    emergencyContactPhone: '9876543213'
  },
  {
    name: 'Arjun Singh',
    age: 80,
    gender: 'Male',
    room: 'Room 108',
    status: 'Stable',
    conditions: ['Heart Condition'],
    allergies: ['Shellfish'],
    emergencyContactName: 'Vikram Singh',
    emergencyContactPhone: '9876543214'
  }
];

const staffUsers = [
  {
    name: 'Rahul Sharma',
    email: 'rahul.demo@saksham.care',
    password: 'password123',
    role: 'Caretaker'
  },
  {
    name: 'Priya Patel',
    email: 'priya.demo@saksham.care',
    password: 'password123',
    role: 'Caretaker'
  }
];

const seedData = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('Connected to MongoDB...');

    // Clean existing demo data (optional, but good for idempotency)
    // We'll only delete the ones we are about to create if they exist by email/name
    // Or just clear all Residents/Staff if the user wants a clean slate for demo.
    // The user said "keep some demo... so tht all ratios... work". 
    // I'll just add them.

    console.log('Seeding staff...');
    const createdStaff = [];
    for (const staff of staffUsers) {
      let user = await User.findOne({ email: staff.email });
      if (!user) {
        user = await User.create(staff);
      }
      
      let staffProfile = await Staff.findOne({ user: user._id });
      if (!staffProfile) {
        staffProfile = await Staff.create({
          user: user._id,
          employeeId: `DEMO-${Math.floor(1000 + Math.random() * 9000)}`,
          designation: 'Senior Caretaker',
          shift: staff.name === 'Rahul Sharma' ? 'Morning' : 'Night',
          status: 'Active'
        });
      }
      createdStaff.push({ user, profile: staffProfile });
    }

    console.log('Seeding residents...');
    for (const resData of residents) {
      let resident = await Resident.findOne({ name: resData.name });
      if (!resident) {
        resident = await Resident.create({
          ...resData,
          assignedCaretaker: createdStaff[Math.floor(Math.random() * createdStaff.length)].user._id
        });

        // Add a sample medicine for adherence tracking
        const med = await Medicine.create({
          resident: resident._id,
          name: 'Vitality Supplement',
          dosage: '1 tablet',
          instructions: 'Once daily after breakfast',
          frequency: 'Daily',
          category: 'Common'
        });

        // Add a today log so adherence is > 0
        await CareLog.create({
          resident: resident._id,
          type: 'medication',
          title: 'Medication Taken',
          description: `Administered ${med.name} to ${resident.name}`,
          caretaker: resident.assignedCaretaker,
          timestamp: new Date()
        });
      }
    }

    console.log('Data seeded successfully!');
    process.exit();
  } catch (error) {
    console.error('Error seeding data:', error);
    process.exit(1);
  }
};

seedData();
