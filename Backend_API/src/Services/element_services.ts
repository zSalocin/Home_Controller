import { Element } from '../Models/element_model';
import Block from '../Models/blocks_model';
import blockService from './blocks_services';

// Falta TESTAR

export async function addElement(userId: string, blockId: string, newElementData: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const newElement = new Element(newElementData); // Pass the data directly
    block.element.push(newElement);
    await block.save();

    await blockService.addelementNumber(blockId);

    return newElement;
  } catch (error) {
    console.error('Error adding a new element:', error);
    throw new Error('Error adding a new element');
  }
}

export async function getElementsInRoom(userId: string, blockId: string, roomName: string) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const elementsInRoom = block.element.filter(element => element.elementRoom === roomName);
    return elementsInRoom;
  } catch (error) {
    console.error('Error getting elements in room:', error);
    throw new Error('Error getting elements in room');
  }
}
export async function getAllElements(blockId: string) {
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

