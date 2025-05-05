const express = require('express');
const session = require('express-session');
const cors = require('cors');
const mongoose = require('mongoose');
const bodyParser = require('body-parser');
const app = express();

// Environment variables for deployment
const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI || "mongodb+srv://sherinmostafa:Multaqa%402024@multaqa.fforxrx.mongodb.net/?retryWrites=true&w=majority&appName=multaqa";
const JWT_SECRET = process.env.JWT_SECRET || "arwa500";

///////////////////session///////
app.use(session({
    secret: JWT_SECRET,
    resave: false,
    saveUninitialized: true,
    cookie: { 
      secure: process.env.NODE_ENV === 'production', 
      sameSite: process.env.NODE_ENV === 'production' ? 'none' : 'lax'
    }
}));

////////////Routers//////////////////////////
const userRouter = require('./src/routers/user.js');
const eventAttendee = require('./src/routers/event-attendee.js')
const feedback = require('./src/routers/feedback.js')
const feedbackAttendee = require('./src/routers/feedback-attendee.js')
const organizer = require('./src/routers/organizer.js')
const photoEvent = require('./src/routers/photo-event.js')
const ticket = require('./src/routers/ticket.js')
const ticketChannel = require('./src/routers/ticket-channel.js')
const plan = require('./src/routers/plan.js')
const userPhone = require('./src/routers/user-phone.js')
const contactUs = require('./src/routers/contact.js')
const event = require("./src/routers/event.js")
const complaint = require('./src/routers/complaint.js')
const category = require('./src/routers/category.js')
const categoryEvent = require('./src/routers/events_under_category.js')
const bankAccount = require('./src/routers/bankAccount.js')
const booking = require('./src/routers/booking.js')
const attendeeDashboard=require('./src/routers/attendee-likes.js')
const admin = require('./src/routers/admin.js')
const deleteRequests = require('./src/routers/deleteRequests.js')

app.use(cors({
    origin: process.env.FRONTEND_URL || '*',
    credentials: true
}));

app.use(bodyParser.json({ limit: '50mb' }));
app.use(bodyParser.urlencoded({ limit: '50mb', extended: true }));

const connectDB = async () => {
    try {
        mongoose.set('strictQuery', false);
        await mongoose.connect(MONGODB_URI, {
          // Remove deprecated options
          // The options below are no longer needed in newer Mongoose versions
          // useNewUrlParser and useUnifiedTopology are default in Mongoose 6+
        });
        console.log('Connected to MongoDB');
    } catch (error) {
        console.error('MongoDB connection error:', error);
        process.exit(1);
    }
}

connectDB();

//////////CALL ROUTERS/////////////////////////////
app.use(express.urlencoded({ extended: true }));
app.use('/', userRouter);
app.use(eventAttendee)
app.use(feedback)
app.use(feedbackAttendee)
app.use(organizer)
app.use(photoEvent)
app.use(ticket)
app.use(ticketChannel)
app.use(plan)
app.use(userPhone)
app.use(contactUs)
app.use(event)
app.use(complaint)
app.use(category)
app.use(categoryEvent)
app.use(bankAccount)
app.use(booking)
app.use(attendeeDashboard)
app.use(admin)
app.use(deleteRequests)

///////////////////////////////////////////////////////////
app.get('/organizer', (req, res) => res.send('Organizer Page'));
app.get('/events', (req, res) => res.send('Attendee Page'));

// Add a health check endpoint for container orchestration platforms
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

// biome-ignore lint/style/useNodejsImportProtocol: <explanation>
const path = require('path');

// Serve static files from the 'uploads' directory
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

// Serve static files for frontend if in the same deployment
app.use(express.static(path.join(__dirname, 'public')));

// Handle SPA routing - always return index.html for non-API routes in production
if (process.env.NODE_ENV === 'production') {
    app.get('*', (req, res, next) => {
        if (req.url.startsWith('/api') || 
            req.url.startsWith('/uploads') || 
            req.url.startsWith('/health')) {
            return next();
        }
        res.sendFile(path.join(__dirname, 'public', 'index.html'));
    });
}

app.listen(PORT, '0.0.0.0', () => {
    console.log(`Server is running on port ${PORT}`);
});
