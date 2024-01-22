// Routes/blocks_router.ts
import express from 'express';
import blockController from '../Controllers/blocks_controller';

const router = express.Router();

router.get('/', blockController.getAllBlocks);
router.get('/:blockId/elements', blockController.getElementsInBlock);
router.get('/:blockId/rooms', blockController.getRoomsInBlock);
router.post('/add', blockController.addBlock);

export default router;
