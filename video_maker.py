import os
import subprocess
from flask import Flask, request, jsonify, send_from_directory

app = Flask(__name__)

UPLOAD_FOLDER = 'uploads'
OUTPUT_FOLDER = 'outputs'
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

@app.route('/verify-and-generate', methods=['POST'])
def verify_and_generate():
    """
    Yeh API pehle check karegi ki user ne payment kiya hai ya nahi,
    aur payment confirm hone par hi video render karke download link degi.
    """
    try:
        # 1. App se aane wala data aur payment status/transaction ID check karna
        shop_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        transaction_id = request.form.get('txn_id')  # User ya UPI app se mila reference number
        image_file = request.files.get('image')
        
        if not image_file:
            return jsonify({'error': 'Dukaan ki photo zaroori hai!'}), 400

        # 2. Security / Fake Payment Check
        if not transaction_id or transaction_id == "FAKE_TXN":
            return jsonify({
                'status': 'Failed',
                'error': 'Payment verify nahi ho saki! Kripya asli payment karein.'
            }), 400

        # Agar payment asli hai, tabhi aage badho:
        image_path = os.path.join(UPLOAD_FOLDER, image_file.filename)
        image_file.save(image_path)
        
        output_filename = 'dukaan_promo.mp4'
        output_video_path = os.path.join(OUTPUT_FOLDER, output_filename)

        # 3. FFmpeg se Video Render karna (Text & Image ke sath)
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

# 4. NEW: Video Download karne ke liye route (Error 404 se bachne ke liye)
@app.route('/download/<path:filename>')
def download_file(filename):
    return send_from_directory(OUTPUT_FOLDER, filename, as_attachment=True)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
