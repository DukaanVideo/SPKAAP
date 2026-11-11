from flask import Flask, render_template_string

app = Flask(__name__)

HTML_PAGE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DukaanVideo Test</title>
</head>
<body style="text-align:center; padding:50px; font-family:Arial;">
    <h1 style="color:green;">🎉 Server Ekdam Perfect Chal Gaya Hai!</h1>
    <p>Ab koi 404 error nahi aayega.</p>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_PAGE)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
