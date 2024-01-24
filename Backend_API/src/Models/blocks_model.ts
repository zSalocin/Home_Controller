import mongoose from 'mongoose';
import {elementSchema} from './element_model';
import {roomSchema} from './room_model';
import {requestSchema} from './request_model';

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