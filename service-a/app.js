import express from "express";
import cors from "cors";
import morgan from "morgan";

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());
app.use(morgan("dev"));

app.get("/", (req, res) => {
  const htmlContent = `
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Service A | Giga Chat</title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
        <style>
            body { font-family: 'Inter', sans-serif; }
            .glass {
                background: rgba(255, 255, 255, 0.05);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.1);
            }
        </style>
    </head>
    <body class="bg-slate-900 text-white h-screen flex items-center justify-center overflow-hidden relative">
        
        <!-- Background Decor -->
        <div class="absolute top-0 left-0 w-96 h-96 bg-blue-600 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob"></div>
        <div class="absolute bottom-0 right-0 w-96 h-96 bg-purple-600 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>

        <!-- Main Card -->
        <div class="glass p-8 rounded-2xl shadow-2xl max-w-md w-full mx-4 relative z-10">
            <div class="flex items-center justify-between mb-6">
                <span class="px-3 py-1 text-xs font-semibold tracking-wider text-green-400 uppercase bg-green-400/10 rounded-full border border-green-400/20">
                    ● System Online
                </span>
                <span class="text-slate-400 text-sm">Port ${port}</span>
            </div>

            <h1 class="text-4xl font-bold mb-2 bg-gradient-to-r from-blue-400 to-purple-400 bg-clip-text text-transparent">
                Service A
            </h1>
            <p class="text-slate-400 mb-8 text-lg font-light">
                Giga Chat Node
            </p>

            <div class="space-y-4">
                <div class="p-4 rounded-xl bg-black/20 border border-white/5">
                    <p class="text-sm text-slate-500 mb-1">Response Message</p>
                    <p class="font-mono text-green-300">"Hello from Service A"</p>
                </div>

                <div class="flex gap-3">
                    <a href="/api/health" target="_blank" class="flex-1 text-center py-3 rounded-xl bg-blue-600 hover:bg-blue-500 transition-all font-medium text-sm">
                        Check API JSON
                    </a>
                </div>
            </div>

            <div class="mt-8 pt-6 border-t border-white/5 text-center">
                <p class="text-xs text-slate-600">Powered by Express & Jenkins CI/CD</p>
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
    uptime: process.uptime()
  });
});

app.listen(port, "0.0.0.0", () => {
  console.log(`🚀 Service A running at http://localhost:${port}`);
});