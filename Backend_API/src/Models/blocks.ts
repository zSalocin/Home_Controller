import mongoose from 'mongoose';

const requestSchema = new mongoose.Schema({
  name: { type: String, required: true },
  pin: { type: Number, required: true },
  stats: { type: Boolean, required: true },
});

const elementSchema = new mongoose.Schema({
  enable: { type: Boolean, required: true },
  stats: { type: Boolean, required: true },
  pin: { type: Number, required: true },
  elementName: { type: String, required: true },
  elementRoom: { type: String, required: true },
  elementType: { type: String, required: true },
  attachPins: [Number] // Somente se elementType contiver 'sensor'
});

const roomSchema = new mongoose.Schema({
  roomName: { type: String, required: true }
});


const blockSchema = new mongoose.Schema({
    name: { type: String, required: true },
    element: [elementSchema],
    requests: [requestSchema],
    room: [roomSchema],
    sensor: [Number],
  });
  

export const blockModel = mongoose.model('Block', blockSchema);

export default blockModel;