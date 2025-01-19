// Import dependencies
const express = require('express');
const mysql = require('mysql');
const bodyParser = require('body-parser');

// Inisialisasi express dan bodyParser
const app = express();
const port = 3000;  // Port yang dapat diakses pada IP

app.use(bodyParser.json());

// Buat koneksi ke database MySQL
const db = mysql.createConnection({
  host: 'localhost',  // Ganti dengan alamat IP jika server berada di tempat lain
  user: 'root',       // Ganti dengan username MySQL Anda
  password: '',       // Ganti dengan password MySQL Anda
  database: 'sehatmobile'
});

// Cek koneksi database
db.connect(err => {
  if (err) throw err;
  console.log('Connected to MySQL database');
});

// Endpoint untuk menambahkan user baru
// Endpoint untuk menambahkan user baru
app.post('/users', (req, res) => {
  const { name, email, password } = req.body;
  const query = 'INSERT INTO users (name, email, password) VALUES (?, ?, ?)';
  db.query(query, [name, email, password], (err, result) => {
    if (err) throw err;
    res.status(201).send({ message: 'User created successfully', user_id: result.insertId });
  });
});



// Endpoint untuk membaca semua users
app.get('/users', (req, res) => {
  const query = 'SELECT * FROM users';
  db.query(query, (err, results) => {
    if (err) throw err;
    res.status(200).json(results);
  });
});

// Endpoint untuk membaca data user berdasarkan user_id
app.get('/users/:user_id', (req, res) => {
  const userId = req.params.user_id;
  const query = 'SELECT * FROM users WHERE user_id = ?';
  db.query(query, [userId], (err, results) => {
    if (err) throw err;
    if (results.length === 0) {
      res.status(404).send({ message: 'User not found' });
    } else {
      res.status(200).json(results[0]);
    }
  });
});

// Endpoint untuk memperbarui data user
app.put('/users/:user_id', (req, res) => {
  const userId = req.params.user_id;
  const { name, email, password } = req.body;
  const query = 'UPDATE users SET name = ?, email = ?, password = ? WHERE user_id = ?';
  db.query(query, [name, email, password, userId], (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) {
      res.status(404).send({ message: 'User not found' });
    } else {
      res.status(200).send({ message: 'User updated successfully' });
    }
  });
});

// Endpoint untuk menghapus user
app.delete('/users/:user_id', (req, res) => {
  const userId = req.params.user_id;
  const query = 'DELETE FROM users WHERE user_id = ?';
  db.query(query, [userId], (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) {
      res.status(404).send({ message: 'User not found' });
    } else {
      res.status(200).send({ message: 'User deleted successfully' });
    }
  });
});

// Endpoint untuk menambahkan dokter baru
app.post('/doctors', (req, res) => {
  const { name, specialization, availability_time } = req.body;
  const query = 'INSERT INTO doctors (name, specialization, availability_time) VALUES (?, ?, ?)';
  db.query(query, [name, specialization, availability_time], (err, result) => {
    if (err) throw err;
    res.status(201).send({ message: 'Doctor created successfully', doctor_id: result.insertId });
  });
});

// Endpoint untuk membaca semua doctors
app.get('/doctors', (req, res) => {
  const query = 'SELECT * FROM doctors';
  db.query(query, (err, results) => {
    if (err) throw err;
    res.status(200).json(results);
  });
});

// Endpoint untuk membaca data doctor berdasarkan doctor_id
app.get('/doctors/:doctor_id', (req, res) => {
  const doctorId = req.params.doctor_id;
  const query = 'SELECT * FROM doctors WHERE doctor_id = ?';
  db.query(query, [doctorId], (err, results) => {
    if (err) throw err;
    if (results.length === 0) {
      res.status(404).send({ message: 'Doctor not found' });
    } else {
      res.status(200).json(results[0]);
    }
  });
});

// Endpoint untuk memperbarui data doctor
app.put('/doctors/:doctor_id', (req, res) => {
  const doctorId = req.params.doctor_id;
  const { name, specialization, availability_time } = req.body;
  const query = 'UPDATE doctors SET name = ?, specialization = ?, availability_time = ? WHERE doctor_id = ?';
  db.query(query, [name, specialization, availability_time, doctorId], (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) {
      res.status(404).send({ message: 'Doctor not found' });
    } else {
      res.status(200).send({ message: 'Doctor updated successfully' });
    }
  });
});

// Endpoint untuk menghapus doctor
app.delete('/doctors/:doctor_id', (req, res) => {
  const doctorId = req.params.doctor_id;
  const query = 'DELETE FROM doctors WHERE doctor_id = ?';
  db.query(query, [doctorId], (err, result) => {
    if (err) throw err;
    if (result.affectedRows === 0) {
      res.status(404).send({ message: 'Doctor not found' });
    } else {
      res.status(200).send({ message: 'Doctor deleted successfully' });
    }
  });
});

// ============================ Registrations CRUD ============================

// Endpoint untuk menambahkan registration baru 
  
  // Endpoint untuk membaca semua registrations
  app.get('/registrations', (req, res) => {
    const query = 'SELECT * FROM registrations';
    db.query(query, (err, results) => {
      if (err) throw err;
      res.status(200).json(results);
    });
  });
  
  // Endpoint untuk membaca data registration berdasarkan registration_id
    app.get('/registrations/:user_id', (req, res) => {
      const userId = req.params.user_id;

      const query = `SELECT * FROM registrations WHERE user_id = ?`;

      db.query(query, [userId], (err, results) => {
          if (err) {
              console.error('Database error:', err);
              return res.status(500).send({ error: 'Database error' });
          }

          res.status(200).send(results);
      });
  });

  
  // Endpoint untuk registrasi pasien
  app.post('/registrations', (req, res) => {
    const { user_id, user_name, hospital, complain } = req.body;

    console.log('Received data:', { user_id, user_name, hospital, complain }); // Log data untuk debugging

    const status = 'pending';

    const query = `
      INSERT INTO registrations (user_id, user_name, hospital, complain, status, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?, NOW(), NOW())
    `;

    db.query(query, [user_id, user_name, hospital, complain, status], (err, result) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).send({ error: 'Database error' });
      }

      res.status(201).send({
        message: 'Registration successfully created',
        registration_id: result.insertId,
      });
    });
  });

  
  // Endpoint untuk menghapus registration
  app.delete('/registrations/:registration_id', (req, res) => {
    const registrationId = req.params.registration_id;
    const query = 'DELETE FROM registrations WHERE registration_id = ?';
    db.query(query, [registrationId], (err, result) => {
      if (err) throw err;
      if (result.affectedRows === 0) {
        res.status(404).send({ message: 'Registration not found' });
      } else {
        res.status(200).send({ message: 'Registration deleted successfully' });
      }
    });
  });

  app.get('/hospitals', (req, res) => {
    const query = 'SELECT * FROM hospitals';
    db.query(query, (err, results) => {
      if (err) {
        console.error('Database error:', err);
        return res.status(500).send({ error: 'Database error' });
      }
      res.status(200).json(results);
    });
  });

    app.get('/registrations/user/:user_name', (req, res) => {
      const userName = req.params.user_name;
      console.log('Received user_name:', userName); // Log untuk memastikan user_name diterima

      const query = `SELECT * FROM registrations WHERE user_name = ?`;

      db.query(query, [userName], (err, results) => {
          if (err) {
              console.error('Database error:', err);
              return res.status(500).send({ error: 'Database error' });
          }

          console.log('Results from database:', results); // Log hasil query
          res.status(200).send(results);
      });
  });

  // Endpoint untuk memperbarui data registration (NEWWWWWWWWWWWW)
  app.put('/registrations/:registration_id', (req, res) => {
    const registrationId = req.params.registration_id;
    const { status } = req.body;
  
    // Validasi nilai status
    if (!['pending', 'approved', 'rejected'].includes(status)) {
      return res.status(400).send({ message: "Invalid status value" });
    }
  
    const query = 'UPDATE registrations SET status = ?, updated_at = NOW() WHERE registration_id = ?';
    db.query(query, [status, registrationId], (err, result) => {
      if (err) throw err;
      if (result.affectedRows === 0) {
        res.status(404).send({ message: 'Registration not found' });
      } else {
        res.status(200).send({ message: 'Registration status updated successfully' });
      }
    });
  });

  
// Start server
const PORT = 3000;
const HOST = '0.0.0.0'; // Terima koneksi dari semua jaringan
app.listen(PORT, HOST, () => {
    console.log(`Server running on http://${HOST}:${PORT}`);
});
