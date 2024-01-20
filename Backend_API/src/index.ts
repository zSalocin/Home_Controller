import express from 'express';
import http from 'http';
import cors from 'cors';
import mongoose from 'mongoose';

const app = express();

app.use(cors({
    credentials: true,
}));

const server = http.createServer(app);

server.listen(8080, () => {
    console.log('server running in http://localhost:8080/');
});

// async function connectToMongo() {
//     const uri = 'mongodb://admin:adminpassword@172.x.x.x:27017/your-database';
  
//     const options = {
//       useNewUrlParser: true,
//       useUnifiedTopology: true,
//       auth: {
//         user: 'admin',
//         password: 'adminpassword',
//       },
//     } as mongoose.ConnectOptions; // Type assertion here
  
//     try {
//       await mongoose.connect(uri, options);
  
//       console.log('Connected to MongoDB');
  
//       // Your code to interact with the database goes here
  
//       await mongoose.disconnect();
//       console.log('Connection closed');
//     } catch (error) {
//       console.error('Error connecting to MongoDB:', error);
//     }
//   }
  
//   connectToMongo();