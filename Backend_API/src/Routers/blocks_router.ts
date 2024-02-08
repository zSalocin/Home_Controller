// Routes/blocks_router.ts
import express from 'express';
import blockController from '../Controllers/blocks_controller';
import * as roomController from '../Controllers/room_controller';
import * as elementController from '../Controllers/element_controller';
import * as requestController from '../Controllers/requests_controller';
import { authenticateUser } from '../Midddlewares/auth_Middleware';

const router = express.Router();

router.use(authenticateUser);

router.get('/get', blockController.getAllBlocks);
router.get('/get/:blockId/Rooms', roomController.getRoom);
router.get('/get/:blockId/allRooms', roomController.getAllRooms);
router.get('/get/:blockId/rooms/:roomName/elements', elementController.getElementsInRoom);

// router.get('/config/micro', blockController.getControllers); ver se tem como adicionar os microcontroles
// router.get('/config/elements', blockController.getElements);


router.post('/add', blockController.addBlock);
router.post('/add/:blockId/rooms', roomController.addRoom);
router.post('/add/:blockId/elements', elementController.addElement);
router.post('/add/:blockId/requests', requestController.addRequest);
router.post('/add/:blockId/elements/:elementId', elementController.addAttachPinToElement);

// router.delete('/delete/:blockId', blockController.removeBlock);
// router.delete('/delete/:blockId/elements/:elementsId', blockController.removeElement);
// router.delete('/delete/:blockId/rooms/:roomsId', blockController.removeRoom);

export default router;


//TODO MAKE ROUTES FOR ELEMENT ADD AND ELEMENT GET