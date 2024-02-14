import Block from '../Models/blocks_model';
import rootUser from '../Models/users';

class BlockService {

// Get Methods

  async getAllBlocks(userId: string): Promise<any[]> {
    try {
      const blocks = await Block.find({ userId }).select('userId name roomNumber elementNumber').lean();
      return blocks;
    } catch (error) {
      console.error('Error fetching all blocks:', error);
      throw new Error('Error fetching all blocks');
    }
  }

// Set Methods

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

  async addRoomNumber(blockId: string) {
    try {
      const block = await Block.findById(blockId);
      if (!block) {
        throw new Error('Block not found');
      }
      
      block.roomNumber += 1;
      await block.save();
      
      return block.roomNumber;
    } catch (error) {
      console.error('Error adding room number:', error);
      throw new Error('Error adding room number');
    }
  }

  async addelementNumber(blockId: string) {
    try {
      const block = await Block.findById(blockId);
      if (!block) {
        throw new Error('Block not found');
      }
      
      block.elementNumber += 1;
      await block.save();
      
      return block.elementNumber;
    } catch (error) {
      console.error('Error adding element number:', error);
      throw new Error('Error adding element number');
    }
  }

  // Update Methods

  // Delete Methods
} 

export default new BlockService();
