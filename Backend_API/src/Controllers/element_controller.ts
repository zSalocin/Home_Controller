import { Request, Response } from 'express';
import * as elementService from '../Services/element_services';
import AuthenticatedRequest from '../Types/types';

export async function addElement(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;
  const newElementData = req.body;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    if (!newElementData || Object.keys(newElementData).length === 0) {
      return res.status(400).json({ error: 'Invalid element data' });
    }

    const newElement = await elementService.addElement(userId, blockId, newElementData);
    res.json(newElement);
  } catch (error) {
    console.error('Error adding a new element:', error);
    res.status(500).json({ error: 'Error adding a new element' });
  }
}

export async function getElement(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;
  const elementId = req.params.elementId;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    const element = await elementService.getElement(userId, blockId, elementId);
    res.json(element);
  } catch (error) {
    console.error('Error getting element:', error);
    res.status(500).json({ error: 'Error getting element' });
  }
}
