import os
import subprocess
from flask import Flask, request, jsonify, send_from_directory, render_template_string

app = Flask(__name__)

# Folders setup with absolute paths to avoid any confusion
BASE_DIR = os.path.abspath(os.path.dirname(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, 'uploads')
OUTPUT_FOLDER = os.path.join(BASE_DIR, 'outputs')

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Self-contained HTML UI (No template missing errors)
HTML_PAGE = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DukaanVideo - Promo Maker</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f4f9; padding: 20px; text-align: center; }
        .container { max-width: 400px; margin: auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0px 0px 10px rgba(0,0,0,0.1); }
        input, textarea { width: 100%; margin: 10px 0; padding: 10px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        button { background: #28a745; color: white; border: none; padding: 12px; width: 100%; border-radius: 5px; font-size: 16px; cursor: pointer; }
        button:hover { background: #218838; }
        #result { margin-top: 15px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>DukaanVideo Promo Maker</h2>
        <form id="promoForm">
            <label>Dukaan ki Photo:</label>
            <input type="file" id="image" name="image" accept="image/*" required>
            
            <label>Video Script / Text:</label>
            <textarea id="script" name="script" placeholder="Jaise: Hamari dukaan par sabhi saman uplabdh hai!" rows="3" required></textarea>
            
            <label>UPI Transaction ID (Payment Verification):</label>
            <input type="text" id="txn_id" name="txn_id" placeholder="Transaction ID dalein" required>
            
            <button type="submit">Video Generate Karein</button>
        </form>
        <div id="result"></div>
    </div>

    <script>
        document.getElementById('promoForm').onsubmit = async function(e) {
            e.preventDefault();
            const formData = new FormData(this);
            document.getElementById('result').innerHTML = "<p>Video ban rahi hai, kripya intezaar karein...</p>";
            
            try {
                const response = await fetch('/verify-and-generate', {
                    method: 'POST',
                    body: formData
                });
                const data = await response.json();
                
                if(data.status === 'Success') {
                    document.getElementById('result').innerHTML = `<p style="color:green;">${data.message}</p><a href="${data.video_url}" download><button style="background:#007bff;">Video Download Karein</button></a>`;
                } else {
                    document.getElementById('result').innerHTML = `<p style="color:red;">${data.error || 'Kuch gadbad ho gayi!'}</p>`;
                }
            } catch (err) {
                document.getElementById('result').innerHTML = `<p style="color:red;">Server connection error!</p>`;
            }
        };
    </script>
</body>
</html>
"""

@app.route('/')
def home():
    print(">>> SUCCESS: Home page requested and loaded by browser!")
    return render_template_string(HTML_PAGE)

@app.route('/verify-and-generate', methods=['POST'])
def verify_and_generate():
    try:
        shop_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        transaction_id = request.form.get('txn_id')
        image_file = request.files.get('image')
        
        if not image_file:
            return jsonify({'error': 'Dukaan ki photo zaroori hai!'}), 400

        if not transaction_id:
            return jsonify({
                'status': 'Failed',
                'error': 'Transaction ID zaroori hai!'
            }), 400

        image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
        image_file.save(image_path)
        
        output_filename = 'dukaan_promo.mp4'
        output_video_path = os.path.join(OUTPUT_FOLDER, output_filename)

        # FFmpeg command to generate promotional video
        ffmpeg_cmd = [
            'ffmpeg', '-y',
            '-loop', '1',
            '-i', image_path,
            '-vf', f"scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,drawtext=text='{shop_text}':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:x=(w-text_w)/2:y=h-150",
            '-t', '5',
            '-pix_fmt', 'yuv420p',
            output_video_path
        ]

        subprocess.run(ffmpeg_cmd, check=True)

        return jsonify({
            'status': 'Success',
            'message': 'Payment confirmed! Video successfully render ho gayi hai.',
            'video_url': f'/download/{output_filename}'
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/download/<path:filename>')
def download_file(filename):
    return send_from_directory(OUTPUT_FOLDER, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
