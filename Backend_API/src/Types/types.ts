// src/types.ts

import { Request } from 'express';

interface AuthenticatedRequest extends Request {
  user?: {
    userId: string;
    // Add any other user properties you need
  };
}

export default AuthenticatedRequest;
