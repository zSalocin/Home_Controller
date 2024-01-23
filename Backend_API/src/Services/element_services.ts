import Element from '../Models/element_model';
import Block from '../Models/blocks_model';

export async function addElement(userId: string, blockId: string, newElementData: any) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const newElement = new Element({ ...newElementData });
    block.element.push(newElement);
    await block.save();

    return newElement;
  } catch (error) {
    console.error('Error adding a new element:', error);
    throw new Error('Error adding a new element');
  }
}

export async function getElement(userId: string, blockId: string, elementId: string) {
  try {
    const block = await Block.findOne({ _id: blockId, userId });

    if (!block) {
      throw new Error('Block not found for the user.');
    }

    const element = block.element.id(elementId);

    if (!element) {
      throw new Error('Element not found in the block.');
    }

    return element;
  } catch (error) {
    console.error('Error getting element:', error);
    throw new Error('Error getting element');
  }
}
