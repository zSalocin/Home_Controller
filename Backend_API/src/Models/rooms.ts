import mongoose from 'mongoose';

const room = new mongoose.Schema({
    roomName: String
  });
  
  export default room;