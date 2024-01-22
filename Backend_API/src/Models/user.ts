import mongoose from 'mongoose';
import blockSchema from './blocks'


const userSchema = new mongoose.Schema({
  username: { type: String, required: true },
  password: { type: String, required: true },
  numBlock: { type: Number, required: true },
  block: [blockSchema]
});

export const userModel = mongoose.model('User', userSchema);

export default userModel;

export const getBlocks = () => userModel.find();

export const getPassWord = (UserID: String) => {  //put the method to password aprove
  return userModel.findById(UserID)
    .then((User) => User ? User.password : null)
    .catch((error) => {
      throw new Error('Error fetching elements in block: ' + error.message);
    });
};

export const getnumBlock = (UserID: String) => {
  return userModel.findById(UserID)
    .then((User) => User ? User.numBlock : null)
    .catch((error) => {
      throw new Error('Error fetching elements in block: ' + error.message);
    });
};