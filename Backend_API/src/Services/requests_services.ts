import { Request } from '../Models/request_model';
import Block from '../Models/blocks_model';

// Falta TESTAR

export async function addRequest(userId: string, blockId: string, newRequestdata: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const newRequest = new Request(newRequestdata); // Pass the data directly
    block.requests.push(newRequest);
    await block.save();

    return newRequest;
  } catch (error) {
    console.error('Error adding a new request:', error);
    throw new Error('Error adding a new request');
  }
}

export async function getRequestinTime(blockId: string) {
  try {
    const currentTime = new Date();
    const requests = await Request.find({ time: { $lt: currentTime }, blockId });

    return requests;
  } catch (error) {
    console.error('Error getting requests in time:', error);
    throw new Error('Error getting requests in time');
  }
}


 export async function getRequestByPin(pin: number, userId: string) {
    return Request.findOne({ pin, userId });
 }


export async function getAllRequests(blockId: string) {
    // this should return all requests of the block
  try {
    const block = await Block.findById(blockId);

    if (!block) {
      throw new Error('Block not found.');
    }

    return block.element;
  } catch (error) {
    console.error('Error getting all elements:', error);
    throw new Error('Error getting all elements');
  }
}

export async function deleteRequestByName(blockId: string, requestName: string) {
  try {
    const block = await Block.findById(blockId);

    if (!block) {
      throw new Error('Block not found.');
    }

    const index = block.requests.findIndex((request: any) => request.name === requestName);

    if (index === -1) {
      throw new Error('Request not found in the block.');
    }

    block.requests.splice(index, 1);
    await block.save();

    return { message: 'Request deleted successfully.' };
  } catch (error) {
    console.error('Error deleting request by name:', error);
    throw new Error('Error deleting request by name');
  }
}


export async function deleteExecutedRequests(blockId: string) {
  try {
    const currentTime = new Date();
    await Request.deleteMany({ time: { $lt: currentTime }, blockId });
  } catch (error) {
    console.error('Error deleting executed requests:', error);
    throw new Error('Error deleting executed requests');
  }
}
