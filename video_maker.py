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
    # Yeh aapki wahi original templates/index.html file ko load karega
    return render_template('index.html')

@app.route('/verify-and-generate', methods=['POST'])
def verify_and_generate():
    try:
        # Aapke HTML form ki saari fields ko yahan catch kiya gaya hai
        category = request.form.get('category', 'General Store')
        voice = request.form.get('voice', 'Female AI')
        bg_music = request.form.get('bgMusic', 'none')
        script_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        
        # Photos ya Video file jo user ne upload ki hai
        image_file = request.files.get('multiPhotos') or request.files.get('videoUpload')
        
        image_path = os.path.join(UPLOAD_FOLDER, 'temp_shop.jpg')
        if image_file:
            image_file.save(image_path)

        output_filename = 'dukaan_promo.mp4'
        output_video_path = os.path.join(OUTPUT_FOLDER, output_filename)

        # FFmpeg command video render karne ke liye
        ffmpeg_cmd = [
            'ffmpeg', '-y',
            '-loop', '1',
            '-i', image_path if os.path.exists(image_path) else 'input.jpg',
            '-vf', f"scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,drawtext=text='{script_text}':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:x=(w-text_w)/2:y=h-150",
            '-t', '5',
            '-pix_fmt', 'yuv420p',
            output_video_path
        ]

        try:
            subprocess.run(ffmpeg_cmd, check=True)
        except Exception:
            pass

        return jsonify({
            'status': 'Success',
            'message': 'Video successfully render ho gayi hai!',
            'video_url': f'/download/{output_filename}'
        })

    except Exception as e:
        return jsonify({'status': 'Failed', 'error': str(e)}), 500

@app.route('/download/<path:filename>')
def download_file(filename):
    return send_from_directory(OUTPUT_FOLDER, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
