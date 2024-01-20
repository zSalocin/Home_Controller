import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  username: String,
  password: String,
  numBlocos: Number,
  blocos: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Bloco'
  }]
});

const User = mongoose.model('User', userSchema);

module.exports = User;
