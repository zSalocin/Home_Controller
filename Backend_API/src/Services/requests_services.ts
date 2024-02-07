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
    // this should return only request that are in time to execute
  try {
    
  } catch (error) {
    console.error('Error getting element:', error);
    throw new Error('Error getting element');
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

