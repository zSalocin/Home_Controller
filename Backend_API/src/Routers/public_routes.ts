// public router
import express from 'express';
import * as elementController from '../Controllers/element_controller';
import * as requestController from '../Controllers/requests_controller';

const publicRouter = express.Router();

publicRouter.get('/get/:blockId/allElements', elementController.getAllElements);
publicRouter.get('/get/:blockId/requests', requestController.getallRequest);
publicRouter.delete('/del/:blockId/requests/:requestName', requestController.deleteRequestByName);

export default publicRouter;
