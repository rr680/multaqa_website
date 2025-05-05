const express = require("express");
const router = express.Router();

router.get("/health", (req, res) => {
  res.status(200).json({ status: "ok", message: "API is healthy" });
});

router.get("/", (req, res) => {
  res.status(200).json({ message: "Multaqa API is running" });
});

module.exports = router;
