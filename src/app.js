import express, { json } from 'express';
import userRouter from '../routes/userRoutes.js'; // Import the userRouter
import adminRouter from '../routes/adminRoutes.js'; // Import the userRouter
import cors from 'cors';
import dotenv from 'dotenv';
dotenv.config();
const app = express();
const lat = process.env.GEO_CENTER_LAT;
const lon = process.env.GEO_CENTER_LON;
console.log('Center Coordinates:', lat, lon);
app.use(json());
app.use(cors());

app.use('/users', userRouter); // Use the userRouter for all /users routes
app.use('/admin', adminRouter);

// so that passsword doesnt get send back to frontend
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});

export default app;
