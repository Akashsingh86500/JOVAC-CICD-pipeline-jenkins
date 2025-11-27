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
              font-family: system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif;
              background: radial-gradient(circle at top, #1f2933, #020617);
              height: 100vh;
              display: flex;
              justify-content: center;
              align-items: center;
              color: #e5e7eb;
          }
          .card {
              padding: 32px 40px;
              border-radius: 18px;
              background: rgba(15, 23, 42, 0.9);
              box-shadow: 0 18px 45px rgba(0, 0, 0, 0.55);
              text-align: center;
              min-width: 320px;
          }
          h1 {
              margin: 0 0 8px;
              font-size: 2rem;
          }
          .badge {
              display: inline-block;
              margin-bottom: 16px;
              padding: 4px 10px;
              border-radius: 999px;
              font-size: 0.75rem;
              text-transform: uppercase;
              letter-spacing: 0.08em;
              border: 1px solid rgba(148, 163, 184, 0.5);
              color: #9ca3af;
          }
          p {
              margin: 0;
              font-size: 0.95rem;
              opacity: 0.9;
          }
          .status {
              margin-top: 16px;
              font-size: 0.9rem;
              opacity: 0.8;
          }
      </style>
  </head>
  <body>
      <div class="card">
          <div class="badge">Service A</div>
          <h1>GIGA CHATT is live</h1>
          <p>Welcome to the Service A landing page.</p>
          <div class="status">
              Health endpoint: <code>/api/health</code>
          </div>
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
