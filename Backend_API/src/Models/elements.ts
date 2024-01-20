import mongoose from 'mongoose';

const element = new mongoose.Schema({
    enable: Boolean,
    stats: Boolean,
    pin: Number,
    elementName: String,
    elementRoom: String,
    elementType: String,
    attachPins: [Number] // Somente se elementType contiver 'sensor'
  });

  export default element;