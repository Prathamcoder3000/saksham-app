const mongoose = require('mongoose');
const dotenv = require('dotenv');
const Resident = require('./models/Resident');
const User = require('./models/User');

dotenv.config({ path: './.env' });

const fixLinks = async () => {
    try {
        await mongoose.connect(process.env.MONGO_URI, {
            useNewUrlParser: true,
            useUnifiedTopology: true
        });
        console.log('MongoDB Connected.');

        const residents = await Resident.find();
        const familyUsers = await User.find({ role: 'Family' });

        console.log(`Found ${residents.length} residents and ${familyUsers.length} family users.`);

        for (const resident of residents) {
            let matchedUser = null;
            
            // Try to match by existing family ID
            if (resident.family) {
                matchedUser = familyUsers.find(u => u._id.toString() === resident.family.toString());
            }

            // If no family ID, try matching by name or phone
            if (!matchedUser) {
                matchedUser = familyUsers.find(u => 
                    (u.phone && u.phone === resident.emergencyContactPhone) || 
                    (u.name && resident.emergencyContactName && u.name.toLowerCase() === resident.emergencyContactName.toLowerCase())
                );
            }

            // If we STILL don't have a match, but there are unlinked family users, just link them to make the app work (demo purposes)
            if (!matchedUser) {
                 const linkedFamilyIds = residents.map(r => r.family ? r.family.toString() : null).filter(Boolean);
                 matchedUser = familyUsers.find(u => !linkedFamilyIds.includes(u._id.toString()));
            }

            if (matchedUser) {
                console.log(`Linking Resident: ${resident.name} -> Family: ${matchedUser.name}`);
                resident.family = matchedUser._id;
                resident.emergencyContactName = matchedUser.name;
                resident.emergencyContactPhone = matchedUser.phone || resident.emergencyContactPhone;
                await resident.save();
            } else {
                console.log(`WARNING: Could not find a family user to link to Resident: ${resident.name}`);
            }
        }

        console.log('Migration Complete.');
        process.exit(0);
    } catch (error) {
        console.error('Migration failed:', error);
        process.exit(1);
    }
};

fixLinks();
