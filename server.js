const express = require('express');
const { Pool } = require('pg');
const path = require('path');
const app = express();

app.use(express.json());
app.use(express.static('public')); // Serves your HTML/CSS

// RDS Connection Details (Populated via Environment Variables in Kubernetes)
const pool = new Pool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  port: 5432,
  // ADD THIS SECTION BELOW
  ssl: {
    rejectUnauthorized: false
  }
});

// Create Table if it doesn't exist
pool.query('CREATE TABLE IF NOT EXISTS users (id SERIAL PRIMARY KEY, name TEXT, email TEXT)');

app.post('/register', async (req, res) => {
  const { name, email } = req.body;
  try {
    await pool.query('INSERT INTO users (name, email) VALUES ($1, $2)', [name, email]);
    res.status(200).send({ message: "Success!" });
  } catch (err) {
    res.status(500).send(err);
  }
});

app.listen(3000, () => console.log('Server running on port 3000'));