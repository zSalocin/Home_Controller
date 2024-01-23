// src/middleware/authMiddleware.ts

import { Request, Response, NextFunction } from 'express';
import jwt, { JwtPayload } from 'jsonwebtoken';

interface AuthenticatedRequest extends Request {
  user?: { userId: string };
}

const secretKey = 'your-secret-key';

export const authenticateUser = (
  req: AuthenticatedRequest,
  res: Response,
  next: NextFunction
) => {
  const token = req.headers.authorization?.split(' ')[1];

  if (!token) {
    return res.status(401).json({ error: 'Token not provided' });
  }

  jwt.verify(token, secretKey, (err, decoded) => {
    if (err || !decoded) {
      return res.status(401).json({ error: 'Invalid token' });
    }

    // Aqui, estamos fazendo uma verificação adicional para garantir que decoded não seja nulo.
    const userId = (decoded as JwtPayload).userId;

    if (!userId) {
      return res.status(401).json({ error: 'Invalid token payload' });
    }

    req.user = { userId };
    next();
  });
};
