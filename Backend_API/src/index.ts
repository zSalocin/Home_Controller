import express from 'express';
import http from 'http';
import cors from 'cors';
import mongoose, { mongo } from 'mongoose';
import blockRoutes from './Routers/blocks_router';
import authRoutes from './Routers/auth_routes';

const app = express();

app.use((req, res, next) => {
    console.log(`Request received: ${req.method} ${req.url}`);
    next();
  });

app.use(cors({
    origin: '*',
    allowedHeaders: 'X-Requested-With, Content-Type, auth-token',
}));

app.use(express.json());
app.use('/auth', authRoutes);
app.use('/blocks', blockRoutes);

const server = http.createServer(app);

server.listen(8080, () => {
    console.log('server running in http://localhost:8080/');
});

const MONGODB_URI = 'mongodb://192.168.48.227:27017/';

async function connectToMongo() {
    const options = {
        useUnifiedTopology: true,
    } as mongoose.ConnectOptions;

    try {
        await mongoose.connect(MONGODB_URI, options);

        console.log('Connected to MongoDB');

        // Your code to interact with the database goes here

        // For example, define your MongoDB models, routes, middleware, etc.

    } catch (error) {
        console.error('Error connecting to MongoDB:', error);
        process.exit(1); // Exit the process on connection error
    }
    process.on('SIGINT', async () => {
        try {
            await mongoose.connection.close();
            console.log('MongoDB connection closed due to Node.js process termination');
            process.exit(0);
        } catch (error) {
            console.error('Error closing MongoDB connection:', error);
            process.exit(1);
        }
    });
}

connectToMongo();