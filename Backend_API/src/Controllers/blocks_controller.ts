// controllers/blockController.js
import { Request, Response } from 'express';
import blockService from '../Services/blocks_services';

class BlockController {
  async getAllBlocks(req: Request, res: Response) {
    try {
      const blocks = await blockService.getAllBlocks();
      res.json(blocks);
    } catch (error) {
      res.status(500).json({ error: 'Erro ao buscar blocos' });
    }
  }

  async getElementsInBlock(req: Request, res: Response) {
    const blockId = req.params.blockId;
    try {
      const elements = await blockService.getElementsInBlock(blockId);
      res.json(elements);
    } catch (error) {
      res.status(500).json({ error: 'Erro ao buscar elementos no bloco' });
    }
  }

  async getRoomsInBlock(req: Request, res: Response) {
    const blockId = req.params.blockId;
    try {
      const rooms = await blockService.getRoomsInBlock(blockId);
      res.json(rooms);
    } catch (error) {
      res.status(500).json({ error: 'Erro ao buscar salas no bloco' });
    }
  }

  async addBlock(req: Request, res: Response) {
    const newBlockData = req.body;
  
    console.log('Request Body:', req.body);
  
    try {
      // Ensure "name" is present in the request body
      if (!newBlockData || !newBlockData.name) {
        console.log('Invalid Request Data:', newBlockData);
        return res.status(400).json({ error: 'Name is required for a new block' });
      }
  
      const newBlock = await blockService.addBlock(newBlockData);
      res.json(newBlock);
    } catch (error) {
      console.error('Error creating a new block:', error);
      res.status(500).json({ error: 'Erro ao criar um novo bloco' });
    }
  }
  
  
}

export default new BlockController();
