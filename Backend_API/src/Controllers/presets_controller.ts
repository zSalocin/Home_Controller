// controllers/elementController.ts
import { Request, Response } from 'express';
import { getValidElements } from '../Services/presets_service';

export function getValidElementTypes(req: Request, res: Response): void {
    try {
        const validElements = getValidElements();
        res.json({ validElements });
    } catch (error) {
        console.error('error when search for valid elements:', error);
        res.status(500).json({ error: 'error for valid elements' });
    }
}
