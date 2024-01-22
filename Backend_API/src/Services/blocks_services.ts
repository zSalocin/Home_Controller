import Block from '../Models/blocks';

class BlockService {
  async getAllBlocks() {
    return await Block.find();
  }

  async getElementsInBlock(blockId: String) {
    const block = await Block.findById(blockId);
    return block ? block.element : null;
  }

  async getRoomsInBlock(blockId: String) {
    const block = await Block.findById(blockId);
    return block ? block.room : null;
  }

  async getRequestsInBlock(blockId: String) {
    const block = await Block.findById(blockId);
    return block ? block.requests : null;
  }

  async getSensorInBlock(blockId: String) {
    const block = await Block.findById(blockId);
    return block ? block.sensor : null;
  }

  async addBlock(newBlockData: any) {
    try {
      const newBlock = new Block(newBlockData);
      await newBlock.save();
      return newBlock;
    } catch (error) {
      console.error('Error creating a new block:', error);
      throw new Error('Erro ao criar um novo bloco(service)');
    }
  }
}
//TODO check the addBlock method, dosent working
export default new BlockService();
