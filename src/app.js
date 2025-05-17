import express, { json } from 'express';
import userRouter from '../routes/userRoutes.js'; // Import the userRouter
import adminRouter from '../routes/adminRoutes.js'; // Import the userRouter
import cors from 'cors';
const app = express();

app.use(json());
app.use(cors());

app.use('/users', userRouter); // Use the userRouter for all /users routes
app.use('/admin', adminRouter);

      // so that passsword doesnt get send back to frontend
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
