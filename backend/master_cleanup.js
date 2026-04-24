const mongoose = require('mongoose');
const dotenv = require('dotenv');
const User = require('./models/User');
const Resident = require('./models/Resident');
const Staff = require('./models/Staff');
const Vitals = require('./models/Vitals');
const Medicine = require('./models/Medicine');
const Task = require('./models/Task');
const Appointment = require('./models/Appointment');
const CareLog = require('./models/CareLog');

dotenv.config({ path: './.env' });

const indianResidentNames = [
    "Ashok Kumar", "Sunita Sharma", "Parvati Joshi", "Ramesh Iyer", "Lata Deshmukh",
    "Anand Patil", "Mohan Gadgil", "Vimala Bhagat", "Harish Chandra", "Shyamrao Patil",
    "Malti Kelkar", "Narayan Agrawal", "Saraswati Vaidya", "Indubai Kulkarni", "Sunita Singh",
    "Gopal Krishna", "Radha Rani"
];

const indianFamilyNames = [
    "Rahul Sharma", "Priya Mehta", "Neha Kulkarni", "Vivek Joshi", "Amit Shinde",
    "Siddharth Rane", "Anjali Rao", "Kunal Naik", "Meenakshi Nair", "Ritu Desai"
];

const indianStaffNames = [
    "Pooja More", "Swarangi Patil", "Akanksha Jadhav", "Prathamesh More", "Rohan Shinde",
    "Suresh Iyer", "Priya Menon", "Snehal Gupta", "Vikram Rathore", "Kavita Reddy"
];

const cleanup = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI);
        console.log('--- SYSTEM OPTIMIZATION START ---');

        // 1. CLEAN USERS
        const users = await User.find();
        console.log(`Auditing ${users.length} users...`);
        for (let i = 0; i < users.length; i++) {
            const user = users[i];
            
            // Standardize names based on role if they look generic or non-Indian
            if (user.role === 'Family') {
                user.name = indianFamilyNames[i % indianFamilyNames.length];
            } else if (user.role === 'Caretaker') {
                user.name = indianStaffNames[i % indianStaffNames.length];
            }
            
            // Fix phone format
            if (!user.phone || !user.phone.startsWith('+91')) {
                user.phone = `+91${Math.floor(7000000000 + Math.random() * 2999999999)}`;
            }
            await user.save();
        }

        // 2. CLEAN RESIDENTS
        const residents = await Resident.find();
        const caretakers = await User.find({ role: 'Caretaker' });
        const families = await User.find({ role: 'Family' });

        console.log(`Auditing ${residents.length} residents...`);
        for (let i = 0; i < residents.length; i++) {
            const resident = residents[i];
            
            // Standardize name
            resident.name = indianResidentNames[i % indianResidentNames.length];
            
            // Fix room format (A-101 style)
            const wing = ['A', 'B', 'C'][Math.floor(Math.random() * 3)];
            const num = 100 + (i % 20);
            resident.room = `${wing}-${num}`;
            
            // Fix age (realistic)
            if (!resident.age || resident.age < 60) {
                resident.age = 65 + Math.floor(Math.random() * 25);
            }

            // Ensure Status is valid
            if (!['Stable', 'Observing', 'Critical'].includes(resident.status)) {
                resident.status = 'Stable';
            }

            // Relationship Correction
            const family = families[i % families.length];
            const caretaker = caretakers[i % caretakers.length];
            
            resident.family = family._id;
            resident.assignedCaretaker = caretaker._id;
            resident.emergencyContactName = family.name;
            resident.emergencyContactPhone = family.phone;

            await resident.save();

            // 3. SEED VITALS (if missing)
            const vitalsCount = await Vitals.countDocuments({ resident: resident._id });
            if (vitalsCount === 0) {
                const sys = 110 + Math.floor(Math.random() * 20);
                const dia = 70 + Math.floor(Math.random() * 15);
                await Vitals.create({
                    resident: resident._id,
                    heartRate: 70 + Math.floor(Math.random() * 15),
                    bloodPressure: `${sys}/${dia}`,
                    oxygenSaturation: 95 + Math.floor(Math.random() * 5),
                    recordedBy: caretaker._id,
                    recordedAt: new Date()
                });
            }
        }

        // 4. CLEAN STAFF COLLECTION (Ensure sync with User)
        const staffRecords = await Staff.find();
        console.log(`Auditing ${staffRecords.length} staff records...`);
        for (const s of staffRecords) {
            const user = await User.findById(s.user);
            if (user) {
                s.name = user.name;
                s.email = user.email;
                s.phone = user.phone;
                await s.save();
            }
        }

        // 5. CHILD RECORDS CLEANUP (Ensure they point to valid residents)
        const validResidentIds = residents.map(r => r._id.toString());
        
        await Medicine.deleteMany({ resident: { $nin: validResidentIds } });
        await Task.deleteMany({ resident: { $nin: validResidentIds } });
        await Appointment.deleteMany({ resident: { $nin: validResidentIds } });
        await CareLog.deleteMany({ resident: { $nin: validResidentIds } });

        // 6. SEED FACILITY
        const Facility = require('./models/Facility');
        await Facility.deleteMany({});
        await Facility.create({
            name: "Saksham Smart Care NGO",
            branchName: "Saksham Main Branch",
            officeAddress: "Sector 14, Gurgaon, Haryana 122001",
            workingHours: "09:00 AM - 07:00 PM",
            branches: ["Gurgaon Main", "Delhi South", "Noida Center"],
            permissions: {
                "Admin": ["all"],
                "Caretaker": ["read_residents", "write_vitals", "write_logs"]
            }
        });

        console.log('--- SYSTEM OPTIMIZATION COMPLETE ---');
        process.exit(0);
    } catch (err) {
        console.error(err);
        process.exit(1);
    }
};

cleanup();
