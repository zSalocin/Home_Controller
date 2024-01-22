import mongoose from 'mongoose';

const requestSchema = new mongoose.Schema({
    name: { type: String, required: true },
    pin: { type: Number, required: true },
    stats: { type: Boolean, required: true },
  });

  export default requestSchema;