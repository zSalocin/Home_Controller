import { Element } from '../Models/element_model';
import Block from '../Models/blocks_model';
import blockService from './blocks_services';

// Get Methods

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

// Set methods

export async function addElement(userId: string, blockId: string, newElementData: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const existingElement = block.element.find(element => element.elementName === newElementData.elementName);
    
    if (existingElement) {
      throw new Error('A element with the same name already exists in this block.');
    }

    const existingPin = block.element.find(element => element.pin === newElementData.pin);
    
    if (existingPin) {
      throw new Error('A element with the same pin already exists in this block.');
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

export async function addAttachPinToElement(userId: string, blockId: string, elementId: string, attachPin: number) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const element = block.element.id(elementId);

    if (!element) {
      throw new Error('Element not found in the block.');
    }
    element.attachPins = element.attachPins || [];
    element.attachPins.push(attachPin);
    await block.save();

    return { message: 'Attach pin added to the element successfully.' };
  } catch (error) {
    console.error('Error adding attach pin to element:', error);
    throw new Error('Error adding attach pin to element');
  }
}

// Update Methods

export async function updateElement(userId: string, blockId: string, elementId: string, updatedElementData: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const elementIndex = block.element.findIndex(element => block.element.id.toString() === elementId);

    if (elementIndex === -1) {
      throw new Error('Element not found in the block.');
    }

    Object.assign(block.element[elementIndex], updatedElementData);
    await block.save();

    return { message: 'Element updated successfully.' };
  } catch (error) {
    console.error('Error updating element:', error);
    throw new Error('Error updating element');
  }
}

// Delete Methods

export async function deleteElement(userId: string, blockId: string, elementId: string) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const elementIndex = block.element.findIndex(element => block.element.id.toString() === elementId);

    if (elementIndex === -1) {
      throw new Error('Element not found in the block.');
    }

    block.element.splice(elementIndex, 1);
    await block.save();

    return { message: 'Element deleted successfully.' };
  } catch (error) {
    console.error('Error deleting element:', error);
    throw new Error('Error deleting element');
  }
}