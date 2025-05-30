const express = require('express');
const mysql = require('mysql2/promise');
const cors = require('cors');
const app = express();
const port = 3001;

app.use(cors());
app.use(express.json());

// Update these with your MySQL credentials
const pool = mysql.createPool({
  host: '127.0.0.1',
  user: 'root',
  password: '1028', // set your password
  database: 'pld', // set your DB name
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

app.get('/subjects', async (req, res) => {
  const [rows] = await pool.query('SELECT id, subject_name FROM Subjects');
  res.json(rows);
});

app.get('/students', async (req, res) => {
  const [rows] = await pool.query('SELECT id, name FROM Students');
  res.json(rows);
});

app.post('/placement-tests', async (req, res) => {
  const { student_id, scores } = req.body;
  if (!student_id || !Array.isArray(scores)) return res.status(400).json({ error: 'Invalid input' });
  try {
    for (const { subject_id, score } of scores) {
      await pool.query('INSERT INTO Placement_tests (student_id, subject_id, score) VALUES (?, ?, ?)', [student_id, subject_id, score]);
    }
    res.json({ success: true });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

app.get('/recommendations/:studentId', async (req, res) => {
  const [rows] = await pool.query('SELECT report FROM Recommendations WHERE student_id = ?', [req.params.studentId]);
  if (rows.length === 0) return res.status(404).json({ error: 'No recommendation found' });
  res.json(rows[0]);
});

app.get('/subjects-good-at/:studentId', async (req, res) => {
  const [rows] = await pool.query(
    'SELECT s.subject_name, sga.current_level FROM Subjects_good_at sga JOIN Subjects s ON sga.subject_id = s.id WHERE sga.student_id = ?',
    [req.params.studentId]
  );
  res.json(rows);
});

app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});
