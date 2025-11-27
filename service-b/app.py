import os
from flask import Flask
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

@app.route('/')
def index():
    return """
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <title>Service B</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: Arial, Helvetica, sans-serif;
                background: linear-gradient(135deg, #1c1c1c, #3b3b98);
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
                letter-spacing: 1px;
                background: rgba(255,255,255,0.1);
                padding: 40px 60px;
                border-radius: 16px;
                backdrop-filter: blur(8px);
            }
        </style>
    </head>
    <body>
        <div class="container">
            hello from <br> <strong>service-b GROUP 3</strong>
        </div>
    </body>
    </html>
    """

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
