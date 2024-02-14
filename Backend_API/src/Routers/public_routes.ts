// public router
import express from 'express';
import * as elementController from '../Controllers/element_controller';
import * as requestController from '../Controllers/requests_controller';
import * as presetsController from '../Controllers/presets_controller';

const publicRouter = express.Router();

publicRouter.get('/get/:blockId/allElements', elementController.getAllElements);
publicRouter.get('/get/:blockId/requests', requestController.getallRequest);
publicRouter.delete('/del/:blockId/requests/:requestName', requestController.deleteRequestByName);
publicRouter.get('/get/validelement', presetsController.getValidElementTypes);

export default publicRouter;
