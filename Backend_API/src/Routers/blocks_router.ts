// Routes/blocks_router.ts
import express from 'express';
import blockController from '../Controllers/blocks_controller';

const router = express.Router();

router.get('/', blockController.getAllBlocks);
router.get('/:blockId/elements', blockController.getElementsInBlock);
// router.get('/:blockId/elements/sensors', blockController.getSensorsInBlock);
// router.get('/:blockId/elements/Actuators', blockActuators.getSensorsInBlock);
router.get('/:blockId/rooms', blockController.getRoomsInBlock);
// router.get('/:blockId/requests', blockController.getRequestsInBlock);

// router.get('/config/micro', blockController.getControllers); ver se tem como adicionar os microcontroles
router.get('/config/elements', blockController.getElements);


router.post('/add', blockController.addBlock);
// router.post(':blockId/add/rooms', blockController.addRoom);
// router.post('/:blockId/add/elements', blockController.addElements);
// router.post('/:blockId/add/requests', blockController.addRequests);

// router.delete('/delete/:blockId', blockController.removeBlock);
// router.delete('/delete/:blockId/elements/:elementsId', blockController.removeElement);
// router.delete('/delete/:blockId/requests/:requestId', blockController.removeRequests);
// router.delete('/delete/:blockId/rooms/:roomsId', blockController.removeRoom);

export default router;
