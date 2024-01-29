// controllers/blockController.js
import { Request, Response } from 'express';
import blockService from '../Services/blocks_services';
import AuthenticatedRequest from '../Types/types';

class BlockController {
  async getAllBlocks(req: AuthenticatedRequest, res: Response) {
    try {
      const userId = req.user?.userId;

      if (!userId) {
        return res.status(401).json({ error: 'User not authenticated'});
      }

      const blocks = await blockService.getAllBlocks(userId);
      res.json(blocks);
    } catch (error) {
      res.status(500).json({ error: 'Error fetching blocks' });
    }
  }

  async addBlock(req: AuthenticatedRequest, res: Response) {
    const userId = req.user?.userId;
    const newBlockData = req.body;

    if (!userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    try {
      if (!newBlockData || !newBlockData.name) {
        return res.status(400).json({ error: 'Name is required for a new block' });
      }

      const newBlock = await blockService.addBlock(userId, newBlockData);
      res.json(newBlock);
    } catch (error) {
      console.error('Error creating a new block:', error);
      res.status(500).json({ error: 'Error creating a new block(controller)' });
    }
  }
  
}

export default new BlockController();
