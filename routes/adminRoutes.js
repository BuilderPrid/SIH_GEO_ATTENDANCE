import { Router } from 'express';
import { checkAdminCredentials, getAllEmployees, predictAttrition } from '../controller/admin.js';

const adminRouter = Router();



adminRouter.post('/checkCredentials', checkAdminCredentials);
adminRouter.get('/getAllEmployees', getAllEmployees);
adminRouter.post('/predictAttrition', predictAttrition);
adminRouter.get('/test', getAllEmployees);

export default adminRouter;
