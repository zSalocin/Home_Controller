// src/routers/authRouter.ts

import express from 'express';
import authController from '../Controllers/auth_Controller';
import { authenticateUser } from '../Midddlewares/auth_Middleware';

const router = express.Router();

// Rota de registro (não requer autenticação)
router.post('/register', authController.register);

// Rota de login (não requer autenticação)
router.post('/login', authController.login);

// Exemplo de rota protegida que requer autenticação
router.get('/protected-route', authenticateUser, (req, res) => {
  // Lógica para manipular a rota protegida
  res.status(200).json({ message: 'Rota protegida acessada com sucesso' });
});

export default router;
