import { PrismaClient } from '@prisma/client';
import bcrypt from "bcrypt";
import { spawn } from 'child_process';
const prisma = new PrismaClient();

export const checkAdminCredentials = async (req, res) => {
  try {
    const { email, password } = req.body;
    console.log(email, password);
    const admin = await prisma.admin.findUnique({ where: { email: email } });
    if (!admin) return res.status(400).json({ msg: "admin id not found." });


    const isMatch = await bcrypt.compare(password, admin.password);
    if (!isMatch) return res.status(400).json({ msg: "Invalid credentials. " });


    delete admin.password;
    res.status(200).json({
      admin: {
        id: admin.id,
        email: admin.email,
        name: admin.name,
      }
    });

  }
  catch (err) {
    res.status(500).json({ error: err.message });
  }
}


export const getAllEmployees = async (req, res) => {
  try {
    const employees = await prisma.user.findMany();

    res.json(employees);
  }
  catch (err) {
    console.error('Error fetching employees:', err);
    res.status(500).json({ error: 'Internal server error' });
  }
};

export const predictAttrition = async (req, res) => {
  try {
    const python = spawn('/home/pridroger/anaconda3/bin/python', ['ml/predict.py']);
    let data = '';
    python.stdout.on('data', (chunk) => {
      data += chunk.toString();
    });

    python.stderr.on('data', (err) => {
      console.error(`Python error: ${err}`);
    });

    python.on('close', () => {
      try {
        const result = JSON.parse(data);
        res.json(result);
      } catch (err) {
        res.status(500).json({ error: "Prediction failed", detail: err.message });
        console.log(err);
      }
    });

    // Send input to Python
    //
    console.log(req.body);
    python.stdin.write(JSON.stringify({ features: req.body }));
    python.stdin.end();
  } catch (err) {
    res.status(500).json({ error: "Unexpected error occurred", detail: err.message });
  }
};
