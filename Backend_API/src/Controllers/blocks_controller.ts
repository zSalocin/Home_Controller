// controllers/blockController.js
import { Request, Response } from 'express';
import blockService from '../Services/blocks_services';
import AuthenticatedRequest from '../Types/types';

class BlockController {

// Get Methods

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

// Set Methods

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
      if (error instanceof Error && error.message.includes('A block with the same name already exists for this user.')) {
        return res.status(402).json({ error: 'Cannot add blocks with the same name for this user.' });
      } else {
        res.status(500).json({ error: 'Error creating a new block' });
      }
    }
  }
  
// Update Methods

// Delete Methods

}

export default new BlockController();
