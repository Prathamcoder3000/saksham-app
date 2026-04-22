const fs = require('fs');
const _path = require('path');
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const NUM_ADMIN = 3;
const NUM_CARETAKER = 6;
const NUM_FAMILY = 10;
const NUM_RESIDENTS = 15;

const dir = _path.join(__dirname, 'dummy_dataset');
if (!fs.existsSync(dir)){
    fs.mkdirSync(dir);
}

const generateId = () => new mongoose.Types.ObjectId();
const hashedPassword = bcrypt.hashSync('Saksham@123', 10);

const adminNames = ['Rajesh Deshmukh', 'Sunita Kadam', 'Vikram Joshi'];
const caretakerNames = ['Pooja Patil', 'Ajay Chavan', 'Sneha Mhatre', 'Ramesh Yadav', 'Kavita Shirke', 'Deepak More'];
const familyNames = ['Amit Shinde', 'Neha Thakur', 'Suresh Iyer', 'Meenakshi Nair', 'Ravi Verma', 'Priya Menon', 'Kunal Naik', 'Anjali Rao', 'Siddharth Rane', 'Ritu Desai'];
const residentNames = ['Mohan Gadgil', 'Lata Deshpande', 'Harish Chandra', 'Vimala Bhagat', 'Ashok Kumar', 'Kamal Nath', 'Pushpa Devi', 'Govind Ranade', 'Shalini Gokhale', 'Shyamrao Patil', 'Malti Kelkar', 'Narayan Agrawal', 'Parvati Sharma', 'Anand Kulkarni', 'Saraswati Vaidya'];

const diseasesList = [['Hypertension', 'Arthritis'], ['Diabetes Type 2'], ['Dementia'], ['Osteoporosis', 'Cataracts'], ['Heart Disease'], ['Asthma'], ['Glaucoma', 'Hypertension'], []];
const rooms = ['A-101', 'A-102', 'A-103', 'A-104', 'B-201', 'B-202', 'B-203', 'B-204', 'C-301', 'C-302'];

// Array Holders
const users = [];
const residents = [];
const medicines = [];
const tasks = [];
const notifications = [];
const reports = []; // simulated shift notes / reports
const appointments = [];
const emergencyLogs = [];

// 1. GENERATE USERS
const adminIds = [];
for(let i=0; i<NUM_ADMIN; i++){
    const id = generateId();
    adminIds.push(id);
    users.push({
        _id: { "$oid": id.toString() },
        name: adminNames[i],
        email: `admin${i+1}@saksham.in`,
        password: hashedPassword,
        role: 'Admin',
        phone: `+91 98${Math.floor(10000000 + Math.random() * 90000000)}`,
        createdAt: { "$date": new Date().toISOString() }
    });
}

const caretakerIds = [];
for(let i=0; i<NUM_CARETAKER; i++){
    const id = generateId();
    caretakerIds.push(id);
    users.push({
        _id: { "$oid": id.toString() },
        name: caretakerNames[i],
        email: `caretaker${i+1}@saksham.in`,
        password: hashedPassword,
        role: 'Caretaker',
        phone: `+91 88${Math.floor(10000000 + Math.random() * 90000000)}`,
        createdAt: { "$date": new Date().toISOString() }
    });
}

const familyIds = [];
for(let i=0; i<NUM_FAMILY; i++){
    const id = generateId();
    familyIds.push(id);
    users.push({
        _id: { "$oid": id.toString() },
        name: familyNames[i],
        email: `family${i+1}@saksham.in`,
        password: hashedPassword,
        role: 'Family',
        phone: `+91 77${Math.floor(10000000 + Math.random() * 90000000)}`,
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 2. GENERATE RESIDENTS
const residentIds = [];
for(let i=0; i<NUM_RESIDENTS; i++){
    const id = generateId();
    residentIds.push(id);
    
    // Assign random caretaker and family
    const cId = caretakerIds[Math.floor(Math.random() * caretakerIds.length)];
    const fId = familyIds[Math.floor(Math.random() * familyIds.length)];

    residents.push({
        _id: { "$oid": id.toString() },
        name: residentNames[i],
        age: 65 + Math.floor(Math.random() * 25),
        gender: i % 2 === 0 ? 'Male' : 'Female',
        room: rooms[Math.floor(Math.random() * rooms.length)],
        status: i % 7 === 0 ? 'Observing' : (i % 14 === 0 ? 'Critical' : 'Stable'),
        conditions: diseasesList[Math.floor(Math.random() * diseasesList.length)],
        allergies: i % 5 === 0 ? ['Dust', 'Peanuts'] : [],
        assignedCaretaker: { "$oid": cId.toString() },
        family: { "$oid": fId.toString() },
        emergencyContactName: familyNames[Math.floor(Math.random() * familyNames.length)],
        emergencyContactPhone: `+91 99${Math.floor(10000000 + Math.random() * 90000000)}`,
        admissionDate: { "$date": new Date(Date.now() - Math.random() * 10000000000).toISOString() },
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 3. GENERATE MEDICINES
const medNames = ['Amlodipine', 'Metformin', 'Atorvastatin', 'Levothyroxine', 'Pantoprazole', 'Ashwagandha Extract'];
for(let i=0; i<30; i++){
    const rId = residentIds[Math.floor(Math.random() * residentIds.length)];
    medicines.push({
        _id: { "$oid": generateId().toString() },
        resident: { "$oid": rId.toString() },
        name: medNames[Math.floor(Math.random() * medNames.length)],
        dosage: '1 Tablet',
        instructions: i % 2 === 0 ? 'After meal' : 'Before breakfast',
        scheduledTime: i % 2 === 0 ? '09:00' : '20:00',
        frequency: 'Daily',
        logs: [], // Empty for now, wait.. add some logs
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 4. GENERATE TASKS
const taskTitles = ['Check blood pressure', 'Administer Morning Meds', 'Assist with lunch', 'Walk in the garden', 'Provide evening tea', 'Physiotherapy session'];
for(let i=0; i<25; i++){
    const cId = caretakerIds[Math.floor(Math.random() * caretakerIds.length)];
    const rId = residentIds[Math.floor(Math.random() * residentIds.length)];
    const todayStr = new Date().toISOString().split('T')[0];

    tasks.push({
        _id: { "$oid": generateId().toString() },
        title: taskTitles[Math.floor(Math.random() * taskTitles.length)],
        time: `${Math.floor(8 + Math.random() * 10)}:00 AM`,
        resident: { "$oid": rId.toString() },
        caretaker: { "$oid": cId.toString() },
        status: i % 3 === 0 ? 'done' : 'pending',
        date: todayStr,
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 5. GENERATE NOTIFICATIONS
const notifTitles = ['Medication Missed', 'Appointment Scheduled', 'Vitals Alert', 'Routine Check-up', 'Visitor Arrival'];
for(let i=0; i<15; i++){
    const fId = familyIds[Math.floor(Math.random() * familyIds.length)];
    notifications.push({
        _id: { "$oid": generateId().toString() },
        user: { "$oid": fId.toString() },
        title: notifTitles[Math.floor(Math.random() * notifTitles.length)],
        message: 'This is an auto-generated system notification detailing care updates.',
        isRead: i % 2 !== 0,
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 6. GENERATE REPORTS / SHIFT NOTES
for(let i=0; i<10; i++){
    const cId = caretakerIds[Math.floor(Math.random() * caretakerIds.length)];
    reports.push({
        _id: { "$oid": generateId().toString() },
        caretaker: { "$oid": cId.toString() },
        date: new Date().toISOString().split('T')[0],
        shift: i % 2 === 0 ? 'Morning' : 'Night',
        notes: 'Handover complete. All residents are stable. Meals consumed actively. No incidents.',
        incidents: i % 8 === 0 ? ['Minor slip - checked by doctor, all ok.'] : [],
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 7. GENERATE APPOINTMENTS
for(let i=0; i<12; i++){
    const rId = residentIds[Math.floor(Math.random() * residentIds.length)];
    const fId = familyIds[Math.floor(Math.random() * familyIds.length)];
    appointments.push({
        _id: { "$oid": generateId().toString() },
        resident: { "$oid": rId.toString() },
        title: 'Routine Doctor Visit',
        subtitle: 'Dr. Shah (Cardiology)',
        type: 'medical',
        scheduledAt: { "$date": new Date(Date.now() + Math.random() * 864000000).toISOString() },
        conductedBy: 'Dr. Shah',
        status: i % 4 === 0 ? 'completed' : 'pending',
        familyMember: { "$oid": fId.toString() },
        createdAt: { "$date": new Date().toISOString() }
    });
}

// 8. GENERATE EMERGENCY LOGS
for(let i=0; i<8; i++){
    const cId = caretakerIds[Math.floor(Math.random() * caretakerIds.length)];
    const resId = adminIds[0];
    emergencyLogs.push({
        _id: { "$oid": generateId().toString() },
        caretaker: { "$oid": cId.toString() },
        location: rooms[Math.floor(Math.random() * rooms.length)],
        note: 'SOS triggered by caretaker.',
        status: 'resolved',
        resolvedBy: { "$oid": resId.toString() },
        resolvedAt: { "$date": new Date().toISOString() },
        timestamp: { "$date": new Date(Date.now() - Math.random() * 1000000).toISOString() }
    });
}

// Write to files
const writeJSON = (filename, data) => {
    fs.writeFileSync(_path.join(dir, filename), JSON.stringify(data, null, 2));
    console.log(`Generated \${filename} with \${data.length} records.`);
};

writeJSON('users.json', users);
writeJSON('residents.json', residents);
writeJSON('medicines.json', medicines);
writeJSON('tasks.json', tasks);
writeJSON('notifications.json', notifications);
writeJSON('reports_shiftnotes.json', reports);
writeJSON('appointments.json', appointments);
writeJSON('emergency_logs.json', emergencyLogs);

console.log('All MongoDB-ready dummy datasets created successfully in dummy_dataset/!');
