import mongoose from 'mongoose';
import blockSchema from './blocks'
import permissionSchema from './permissions'

const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  password: { type: String, required: true },
  numBlock: { type: Number, required: true },
  permissions: [permissionSchema],
});

const rootuserSchema = new mongoose.Schema({
  username: { type: String, required: true },
  password: { type: String, required: true },
  numBlock: { type: Number, required: true },
  block: [blockSchema]
});

export const rootuserModel = mongoose.model('rootUser', rootuserSchema);

export default rootuserModel;