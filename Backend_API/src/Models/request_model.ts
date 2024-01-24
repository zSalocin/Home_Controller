import mongoose from "mongoose";

export const requestSchema = new mongoose.Schema({
    name: { type: String, required: true },
    pin: { type: Number, required: true },
    stats: { type: Boolean, required: true },
  });

  export const Request = mongoose.model('Request', requestSchema);
