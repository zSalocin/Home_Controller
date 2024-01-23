// src/controllers/authController.ts

import { Request, Response } from 'express';
import * as authService from '../Services/auth_services';

const authController = {
  register: authService.registerUser,
  login: authService.loginUser,
};

export default authController;
