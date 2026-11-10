import os
import subprocess
from flask import Flask, request, jsonify

app = Flask(__name__)

# Temporary folders for media storage
UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'outputs'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/generate-video', methods=['POST'])
def generate_video():
    """
    Yeh API photo, text script aur audio ko lekar FFmpeg ke zariye 
    ek final .mp4 promotional video render karegi.
    """
    try:
        # 1. User ka data receive karna
        shop_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        image_file = request.files.get('image')
        
        if not image_file:
            return jsonify({'error': 'Dukaan ki photo ya media zaroori hai!'}), 400

        # File save karna
        image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
        image_file.save(image_path)
        
        output_video_path = os.path.join(OUTPUT_FOLDER, 'dukaan_promo.mp4')

        # 2. FFmpeg command se Image + Text ko Video mein badalna
        # (Yeh command 5 second ki HD video banayegi jisme text overlay hoga)
        ffmpeg_cmd = [
            'ffmpeg', '-y',
            '-loop', '1',
            '-i', image_path,
            '-vf', f"scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2,drawtext=text='{shop_text}':fontcolor=white:fontsize=48:box=1:boxcolor=black@0.5:x=(w-text_w)/2:y=h-150",
            '-t', '5',
            '-pix_fmt', 'yuv420p',
            output_video_path
        ]

        # Command execute karna
        subprocess.run(ffmpeg_cmd, check=True)

        # 3. Success Response bhejna
        return jsonify({
            'status': 'Success',
            'message': 'Video successfully render ho gayi hai!',
            'video_url': f'/download/{output_video_path}'
        })

    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == '__main__':
    # Server run karne ke liye (Port 5000)
    app.run(host='0.0.0.0', port=5000, debug=True)
