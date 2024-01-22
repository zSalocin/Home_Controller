import mongoose from 'mongoose';
import element from "./elements";
import request from "./requests";
import room from "./rooms";

const blockSchema = new mongoose.Schema({
    name: { type: String, required: true },
    element: [element],
    requests: [request],
    room: [room],
    sensor: [Number],
  });
  
export const blockModel = mongoose.model('Block', blockSchema);

export default blockModel;

export const getBlocks = () => blockModel.find();

export const getElementsInBlock = (blockId: String) => {
  return blockModel.findById(blockId)
    .then((block) => block ? block.element : null)
    .catch((error) => {
      throw new Error('Error fetching elements in block: ' + error.message);
    });
};

export const getRoomsInBlock = (blockId: String) => {
  return blockModel.findById(blockId)
    .then((block) => block ? block.room : null)
    .catch((error) => {
      throw new Error('Error fetching room in block: ' + error.message);
    });
};

export const getRequestsInBlock = (blockId: String) => {
  return blockModel.findById(blockId)
    .then((block) => block ? block.requests : null)
    .catch((error) => {
      throw new Error('Error fetching requests in block: ' + error.message);
    });
};

export const getSensorsInBlock = (blockId: String) => {
  return blockModel.findById(blockId)
    .then((block) => block ? block.sensor : null)
    .catch((error) => {
      throw new Error('Error fetching sensor in block: ' + error.message);
    });
};