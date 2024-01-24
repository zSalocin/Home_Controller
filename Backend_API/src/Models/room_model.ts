import mongoose from "mongoose";

export const roomSchema = new mongoose.Schema({
    roomName: { type: String, required: true }
  });

  export const Room = mongoose.model('Room', roomSchema);