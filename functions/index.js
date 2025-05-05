const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

admin.initializeApp();
const db = admin.firestore();

const app = express();
app.use(cors({ origin: true }));

// GET /productos
app.get('/productos', async (req, res) => {
  const snapshot = await db.collection('videojuego').get();
  const productos = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
  res.status(200).json(productos);
});

// POST /productos
app.post('/productos', async (req, res) => {
  const data = req.body;
  if (!data.nombre || !data.precio) {
    return res.status(400).send("Faltan campos requeridos");
  }

  const docRef = await db.collection('videojuego').add(data);
  res.status(201).json({ id: docRef.id });
});

// PUT /productos/:id
app.put('/productos/:id', async (req, res) => {
  const { id } = req.params;
  const data = req.body;

  await db.collection('videojuego').doc(id).update(data);
  res.status(200).send("Producto actualizado");
});

// DELETE /productos/:id
app.delete('/productos/:id', async (req, res) => {
  const { id } = req.params;

  await db.collection('videojuego').doc(id).delete();
  res.status(200).send("Producto eliminado");
});

// Exporta como función Firebase
exports.api = functions.https.onRequest(app);
