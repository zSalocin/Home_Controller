import { Request, Response } from 'express';
import * as requestService from '../Services/requests_services';
import AuthenticatedRequest from '../Types/types';

export async function addRequest(req: AuthenticatedRequest, res: Response) {
const blockId = req.params.blockId;
  const newRequestData = req.body;

  try {
    if (!newRequestData || !newRequestData.pin) {
      return res.status(400).json({ error: 'Pin is required for a new request' });
    }

    const userId = req.user?.userId;
    if (!userId) {
      return res.status(401).json({ error: 'User not authenticated' });
    }

    const existingRequest = await requestService.getRequestByPin(newRequestData.pin, userId);
    if (existingRequest) {
      return res.status(400).json({ error: 'A request with the same pin already exists' });
    }

    const newRequest = await requestService.addRequest(userId, blockId, newRequestData);
    res.json(newRequest);
  } catch (error) {
    console.error('Error creating a new request:', error);
    res.status(500).json({ error: 'Error creating a new request' });
  }
}

export async function getRequestInTime(req: Request, res: Response) {
  const blockId = req.params.blockId;

  try {
    const requests = await requestService.getRequestinTime(blockId);
    res.json(requests);
  } catch (error) {
    console.error('Error getting requests in time:', error);
    res.status(500).json({ error: 'Error getting requests in time' });
  }
}

export async function getallRequest(req: Request, res: Response) {
  const blockId = req.params.blockId;

  try {
    const requests = await requestService.getAllRequests(blockId);
    res.json(requests);
  } catch (error) {
    console.error('Error getting requests', error);
    res.status(500).json({ error: 'Error getting requests' });
  }
}

export async function deleteRequestByName(req: Request, res: Response) {
  const blockId = req.params.blockId;
  const requestName = req.params.requestName;

  try {
    await requestService.deleteRequestByName(blockId, requestName);
    res.status(204).end();
  } catch (error) {
    res.status(500).json({ error: error });
  }
}

export async function deleteExecutedRequests(req: Request, res: Response) {
  const blockId = req.params.blockId;

  try {
    await requestService.deleteExecutedRequests(blockId);
    res.status(204).send(); // No Content response
  } catch (error) {
    console.error('Error deleting executed requests:', error);
    res.status(500).json({ error: 'Error deleting executed requests' });
  }
}