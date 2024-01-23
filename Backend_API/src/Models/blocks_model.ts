import mongoose from 'mongoose';
import elementSchema from './element_model';

const requestSchema = new mongoose.Schema({
  name: { type: String, required: true },
  pin: { type: Number, required: true },
  stats: { type: Boolean, required: true },
});

const roomSchema = new mongoose.Schema({
  roomName: { type: String, required: true }
});


const blockSchema = new mongoose.Schema({
    userId: { type: String, required: true },
    name: { type: String, required: true },
    element: [elementSchema],
    requests: [requestSchema],
    room: [roomSchema],
    sensor: [{ type: Number }],
  });
  

export const blockModel = mongoose.model('Block', blockSchema);

export default blockModel;