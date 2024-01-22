import mongoose from 'mongoose';

const roomSchema = new mongoose.Schema({
    roomName: { type: String, required: true }
  });
  
  export default roomSchema;