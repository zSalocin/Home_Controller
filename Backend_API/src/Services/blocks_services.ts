import Block from '../Models/blocks';

class BlockService {

  ElementType = ['sensor', 'arcondicionado', 'outro_tipo'];

  async getAllBlocks(): Promise<any[]> {
    try {
      const blocks = await Block.find();
      return blocks;
    } catch (error) {
      console.error('Error fetching all blocks:', error);
      throw new Error('Erro ao buscar todos os blocos');
    }
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

  async getElementsType(){
    return this.ElementType;
  }

  async addBlock(newBlockData: any) {
    try {
      // Verifica se já existe um bloco com o mesmo nome
      const existingBlock = await Block.findOne({ name: newBlockData.name });
  
      if (existingBlock) {
        throw new Error('Um bloco com o mesmo nome já existe.');
      }
  
      // Cria um novo bloco se não houver conflito de nome
      const newBlock = new Block(newBlockData);
      await newBlock.save();
  
      return newBlock;
    } catch (error) {
      if (error instanceof Error && error.message.includes('Um bloco com o mesmo nome já existe.')) {
        // Mensagem específica para o caso de bloco com mesmo nome
        throw new Error('Não é permitido adicionar blocos com o mesmo nome.');
      } else {
        // Mensagem genérica para outros erros
        console.error('Error creating a new block:', error);
        throw new Error('Erro ao criar um novo bloco');
      }
    }
  }
}
//TODO check the addBlock method, dosent working
export default new BlockService();
