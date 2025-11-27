import express from "express";
import cors from "cors";
import dotenv from "dotenv";

dotenv.config()

const app = express();
const port = process.env.PORT || 3000;

app.use(cors());

app.get("/", (req, res) => {
  const htmlContent = `
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>JOVAC DevOps - CI/CD Pipelines</title>
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #0f172a;
            background-image: 
                radial-gradient(at 0% 0%, hsla(253,16%,7%,1) 0, transparent 50%), 
                radial-gradient(at 50% 0%, hsla(225,39%,30%,1) 0, transparent 50%), 
                radial-gradient(at 100% 0%, hsla(339,49%,30%,1) 0, transparent 50%);
        }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(16px);
            -webkit-backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            box-shadow: 0 4px 30px rgba(0, 0, 0, 0.1);
        }

        .anim-float {
            animation: float 6s ease-in-out infinite;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
            100% { transform: translateY(0px); }
        }

        .jenkins-glow {
            filter: drop-shadow(0 0 10px rgba(211, 56, 51, 0.5));
        }

        .aws-glow {
            filter: drop-shadow(0 0 10px rgba(255, 153, 0, 0.5));
        }
    </style>
</head>
<body class="min-h-screen flex items-center justify-center p-4 text-white overflow-hidden relative">

    <!-- Decorative Background Elements -->
    <div class="absolute top-10 left-10 w-32 h-32 bg-purple-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob"></div>
    <div class="absolute bottom-10 right-10 w-32 h-32 bg-yellow-500 rounded-full mix-blend-multiply filter blur-3xl opacity-20 animate-blob animation-delay-2000"></div>

    <!-- Main Card -->
    <div class="glass-card rounded-3xl p-8 md:p-12 max-w-lg w-full relative z-10 border-t-4 border-indigo-500 shadow-2xl transform transition-all hover:scale-[1.01] duration-500">
        
        <!-- Header / University -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-full bg-indigo-600 mb-4 shadow-lg shadow-indigo-500/50">
                <i class="fas fa-university text-2xl text-white"></i>
            </div>
            <h3 class="text-indigo-300 font-semibold tracking-widest text-sm uppercase mb-1">Presented By</h3>
            <h1 class="text-3xl font-bold bg-clip-text text-transparent bg-gradient-to-r from-white to-indigo-200">
                GLA UNIVERSITY
            </h1>
        </div>

        <!-- Course Content -->
        <div class="bg-slate-800/50 rounded-2xl p-6 mb-8 border border-white/5 text-center group hover:bg-slate-800/70 transition-colors">
            <h2 class="text-4xl font-extrabold text-white mb-2 tracking-tight">JOVAC DEVOPS</h2>
            <div class="h-1 w-24 bg-gradient-to-r from-orange-500 to-red-500 mx-auto rounded-full mb-4"></div>
            <p class="text-slate-300 text-lg font-light leading-relaxed">
                Mastering <span class="font-semibold text-white">CI/CD Pipelines</span><br>
                Using <span class="text-orange-400 font-medium">Jenkins</span> on <span class="text-yellow-400 font-medium">AWS</span>
            </p>

            <!-- Tech Icons -->
            <div class="flex justify-center gap-6 mt-6">
                <div class="flex flex-col items-center group-hover:-translate-y-2 transition-transform duration-300">
                    <i class="fab fa-jenkins text-4xl text-red-500 jenkins-glow mb-2"></i>
                    <span class="text-xs text-slate-400">Jenkins</span>
                </div>
                <div class="flex flex-col items-center group-hover:-translate-y-2 transition-transform duration-300 delay-100">
                    <i class="fab fa-aws text-4xl text-yellow-500 aws-glow mb-2"></i>
                    <span class="text-xs text-slate-400">AWS</span>
                </div>
                <div class="flex flex-col items-center group-hover:-translate-y-2 transition-transform duration-300 delay-200">
                    <i class="fas fa-infinity text-4xl text-blue-400 mb-2"></i>
                    <span class="text-xs text-slate-400">DevOps</span>
                </div>
            </div>
        </div>

        <!-- Mentor Section -->
        <div class="flex items-center bg-white/5 rounded-xl p-4 border border-white/10 hover:border-indigo-500/30 transition-colors">
            <div class="relative">
                <div class="w-12 h-12 rounded-full bg-gradient-to-br from-indigo-500 to-purple-600 flex items-center justify-center text-lg font-bold shadow-lg">
                    GD
                </div>
                <div class="absolute -bottom-1 -right-1 w-4 h-4 bg-green-500 border-2 border-slate-900 rounded-full"></div>
            </div>
            <div class="ml-4">
                <p class="text-slate-400 text-xs uppercase font-bold tracking-wider">Course Mentor</p>
                <h4 class="text-xl font-semibold text-white">Garvit Dohere Sir</h4>
            </div>
            <div class="ml-auto">
                <i class="fas fa-chalkboard-teacher text-indigo-400 text-xl opacity-50"></i>
            </div>
        </div>

        <!-- Call to Action -->
        <button class="w-full mt-8 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-500 hover:to-purple-500 text-white font-bold py-3 px-6 rounded-xl shadow-lg shadow-indigo-500/30 transform active:scale-95 transition-all flex items-center justify-center gap-2 group">
            <span>Access Pipeline</span>
            <i class="fas fa-arrow-right group-hover:translate-x-1 transition-transform"></i>
        </button>

    </div>

    <script>
        // Simple console log to show the script is active
        console.log("JOVAC DevOps Page Loaded Successfully");
    </script>
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
