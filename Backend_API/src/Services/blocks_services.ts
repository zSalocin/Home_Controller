import Block from '../Models/blocks_model';
import rootUser from '../Models/users';

class BlockService {

  ElementType = ['sensor', 'arcondicionado', 'outro_tipo'];

  async getAllBlocks(userId: string): Promise<any[]> {
    try {
      // Assuming user authentication is handled, and you have the user's ID
      // You can use the user's ID to filter blocks if needed
      const blocks = await Block.find({ userId });
      return blocks;
    } catch (error) {
      console.error('Error fetching all blocks:', error);
      throw new Error('Error fetching all blocks');
    }
  }

  async addBlock(userId: string, newBlockData: any) {
    try {
      const existingBlock = await Block.findOne({ name: newBlockData.name, userId });
  
      if (existingBlock) {
        throw new Error('A block with the same name already exists for this user.');
      }
  
      const newBlock = new Block({ ...newBlockData, userId });
      await newBlock.save();
  
      return newBlock;
    } catch (error) {
      console.error('Error creating a new block. Data:', newBlockData, 'UserId:', userId, 'Error:', error);
      
      if (error instanceof Error && error.message.includes('A block with the same name already exists for this user.')) {
        throw new Error('Cannot add blocks with the same name for this user.');
      } else {
        throw new Error('Error creating a new block');
      }
    }
  }
} 

//TODO check the addBlock method, dosent working
export default new BlockService();
