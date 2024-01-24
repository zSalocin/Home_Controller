import mongoose from 'mongoose';

export const elementSchema = new mongoose.Schema({
    enable: { type: Boolean, required: true },
    stats: { type: Boolean, required: true },
    pin: { type: Number, required: true },
    elementName: { type: String, required: true },
    elementRoom: { type: String, required: true },
    elementType: { type: String, required: true },
    attachPins: [Number] // Somente se elementType contiver 'sensor'
  });

  export const Element = mongoose.model('Element', elementSchema);