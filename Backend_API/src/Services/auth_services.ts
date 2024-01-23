// src/services/authService.ts

import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import { Request, Response } from 'express';
import rootUser from '../Models/users';

const saltRounds = 10;
const secretKey = 'your-secret-key';
export const registerUser = async (req: Request, res: Response) => {
    try {
      const { username, password } = req.body;
  
      const existingUser = await rootUser.findOne({ username });
  
      if (existingUser) {
        return res.status(400).json({ error: 'Username already exists' });
      }
  
      const hashedPassword = await bcrypt.hash(password, saltRounds);
  
      const newUser = new rootUser({ username, password: hashedPassword, blocks: [] });
      await newUser.save();
  
      res.status(201).json({ message: 'User registered successfully' });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
  
  export const loginUser = async (req: Request, res: Response) => {
    try {
      const { username, password } = req.body;
  
      const user = await rootUser.findOne({ username });
  
      if (!user || !(await bcrypt.compare(password, user.password))) {
        return res.status(401).json({ error: 'Invalid credentials' });
      }
  
      const token = jwt.sign({ userId: user._id }, secretKey, {
        expiresIn: '1h',
      });
  
      res.status(200).json({ token });
    } catch (error) {
      console.error(error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };