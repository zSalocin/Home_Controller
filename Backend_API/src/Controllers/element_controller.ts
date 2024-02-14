import { Request, Response } from 'express';
import * as elementService from '../Services/element_services';
import AuthenticatedRequest from '../Types/types';

// Get Methods

export async function getElementsInRoom(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;
  const roomName = req.params.roomName;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    const elementsInRoom = await elementService.getElementsInRoom(userId, blockId, roomName);
    res.json(elementsInRoom);
  } catch (error) {
    console.error('Error getting elements in room:', error);
    res.status(500).json({ error: 'Error getting elements in room' });
  }
}

export async function getAllElements(req: Request, res: Response) {
  const blockId = req.params.blockId;

  try {
    const elements = await elementService.getAllElements(blockId);
    res.json(elements);
  } catch (error) {
    console.error('Error getting all elements:', error);
    res.status(500).json({ error: 'Error getting all elements' });
  }
}

// Set Methods

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

export async function addAttachPinToElement(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;
  const elementId = req.params.elementId;
  const attachPin = req.body.attachPin;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    if (!attachPin || isNaN(attachPin)) {
      return res.status(400).json({ error: 'Invalid attach pin' });
    }

    const result = await elementService.addAttachPinToElement(userId, blockId, elementId, attachPin);
    res.json(result);
  } catch (error) {
    console.error('Error adding attach pin to element:', error);
    res.status(500).json({ error: 'Error adding attach pin to element' });
  }
}

// Update Methods

// Delete Methods