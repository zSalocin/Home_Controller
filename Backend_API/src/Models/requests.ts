import mongoose from 'mongoose';

const request = new mongoose.Schema({
    name: String,
    pin: Number,
    stats: Boolean
  });

  export default request;