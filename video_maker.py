import os
import subprocess
from flask import Flask, request, jsonify, send_from_directory, render_template

app = Flask(__name__)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, 'uploads')
OUTPUT_FOLDER = os.path.join(BASE_DIR, 'outputs')

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/')
def home():
    # Yeh seedha aapke 'templates' folder ke andar rakhi index.html ko utha lega
    return render_template('index.html')

@app.route('/verify-and-generate', methods=['POST'])
def verify_and_generate():
    try:
        shop_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        transaction_id = request.form.get('txn_id')
        image_file = request.files.get('image')
        
        if not image_file:
            return jsonify({'error': 'Dukaan ki photo zaroori hai!'}), 400

        if not transaction_id:
            return jsonify({'status': 'Failed', 'error': 'Transaction ID zaroori hai!'}), 400

        image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
        image_file.save(image_path)
        
        output_filename = 'dukaan_promo.mp4'
        output_video_path = os.path.join(OUTPUT_FOLDER, output_filename)

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
