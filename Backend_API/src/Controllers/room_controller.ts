import { Request, Response } from 'express';
import * as roomService from '../Services/room_services';
import AuthenticatedRequest from '../Types/types';

export async function addRoom(req: AuthenticatedRequest, res: Response) {
    const userId = req.user?.userId;
    const blockId = req.params.blockId;
    const newRoomData = req.body;
  
    if (!userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }
  
    try {
      if (!newRoomData || Object.keys(newRoomData).length === 0) {
        return res.status(400).json({ error: 'Invalid element data' });
      }
  
      const newRoom = await roomService.addRoom(userId, blockId, newRoomData);
      res.json(newRoom);
    } catch (error) {
      console.error('Error adding a new room:', error);
      res.status(500).json({ error: 'Error adding a new room' });
    }
  }

export async function getAllRooms(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    const rooms = await roomService.getAllRooms(userId, blockId);
    res.json(rooms);
  } catch (error) {
    console.error('Error getting all rooms:', error);
    res.status(500).json({ error: 'Error getting all rooms' });
  }
}

export async function getRoom(req: AuthenticatedRequest, res: Response) {
  const userId = req.user?.userId;
  const blockId = req.params.blockId;
  const roomId = req.params.roomId;

  if (!userId) {
    return res.status(401).json({ error: 'User not authenticated' });
  }

  try {
    const room = await roomService.getRoom(userId, blockId, roomId);
    res.json(room);
  } catch (error) {
    console.error('Error getting room:', error);
    res.status(500).json({ error: 'Error getting room' });
  }
}
