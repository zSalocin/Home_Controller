import mongoose from 'mongoose';
import blockModel from './blocks_model';
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
  numBlock: { type: Number, required: false },
});

export const rootuserModel = mongoose.model('rootUser', rootuserSchema);

export default rootuserModel;