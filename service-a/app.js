import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());

app.get("/", (req, res) => {
  const htmlContent = `
  <!DOCTYPE html>
  <html lang="en">
  <head>
      <meta charset="UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1.0" />
      <title>Service A</title>
      <style>
          body {
              margin: 0;
              padding: 0;
              font-family: Arial, Helvetica, sans-serif;
              background: linear-gradient(135deg, #0f0f0f, #2323a5);
              height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
              color: #fff;
          }
          .container {
              text-align: center;
              font-size: 2rem;
              font-weight: 600;
              padding: 40px 60px;
              border-radius: 14px;
              background: rgba(255, 255, 255, 0.12);
              backdrop-filter: blur(10px);
              letter-spacing: 1px;
          }
          h1 {
              margin: 0 0 10px 0;
              font-size: 2.5rem;
          }
          p {
              opacity: 0.9;
              font-size: 1.2rem;
          }
      </style>
  </head>
  <body>
      <div class="container">
          <h1>Service A</h1>
          <p>🚀 Welcome to GIGA CHATT headquarters</p>
      </div>
  </body>
  </html>
  `;
  res.send(htmlContent);
});

app.get("/api/health", (req, res) => {
  res.json({
    service: "Service A",
    status: "active",
    message: "GIGA CHATT IS LIVE",
    timestamp: new Date().toISOString(),
    uptime: process.uptime(),
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`🚀 Service A running at http://localhost:${port}`);
});

export default app;