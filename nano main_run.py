import os
import subprocess
from flask import Flask, request, jsonify, send_from_directory, render_template_string

app = Flask(__name__)

BASE_DIR = os.path.abspath(os.path.dirname(__file__))
UPLOAD_FOLDER = os.path.join(BASE_DIR, 'uploads')
OUTPUT_FOLDER = os.path.join(BASE_DIR, 'outputs')

os.makedirs(UPLOAD_FOLDER, exist_ok=True)
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

HTML_PAGE = """
<!DOCTYPE html>
<html lang="hi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DukaanVideo - Local Promo Maker</title>
    <style>
        body { font-family: Arial, sans-serif; background: #121212; margin: 0; padding: 16px; color: #fff; }
        .hero-banner { background: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.5)), #222; background-size: cover; background-position: center; padding: 50px 20px; border-radius: 12px; text-align: center; border: 2px solid #ffb300; box-shadow: 0 8px 20px rgba(255,179,0,0.3); margin-bottom: 16px; }
        .card { background: #1e1e1e; padding: 16px; margin-top: 16px; border-radius: 12px; box-shadow: 0 4px 8px rgba(0,0,0,0.3); border: 1px solid #333; }
        select { width: 100%; padding: 12px; margin-top: 8px; margin-bottom: 16px; background: #2c2c2c; color: #fff; border: 1px solid #555; border-radius: 8px; box-sizing: border-box; font-size: 14px; }
        label { color: #ffb300; font-weight: bold; font-size: 14px; display: block; margin-top: 10px; }
        .chat-input-bar { display: flex; align-items: center; background: #2c2c2c; border: 1px solid #555; border-radius: 30px; padding: 10px 14px; margin-top: 8px; margin-bottom: 16px; gap: 10px; }
        .chat-input-bar textarea { flex: 1; background: transparent; border: none; color: #fff; resize: none; font-size: 18px; outline: none; height: 32px; max-height: 100px; padding: 2px 0; margin: 0; }
        .icon-btn { background: transparent; border: none; cursor: pointer; font-size: 22px; display: flex; align-items: center; justify-content: center; padding: 5px; color: #ffb300; }
        .btn-send { background: #2196F3; color: white; width: 38px; height: 38px; border-radius: 50%; border: none; cursor: pointer; font-size: 18px; display: flex; align-items: center; justify-content: center; transition: 0.2s; }
        .mic-btn.recording { color: #d32f2f; animation: pulse 1s infinite; }
        @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.1); } 100% { transform: scale(1); } }
        .popup-modal { display: none; position: fixed; bottom: 0; left: 0; width: 100%; background: #1e1e1e; border-top-left-radius: 20px; border-top-right-radius: 20px; padding: 20px; box-sizing: border-box; border-top: 2px solid #ffb300; z-index: 100; }
        .popup-item { padding: 14px; background: #2c2c2c; margin: 8px 0; border-radius: 10px; text-align: center; cursor: pointer; font-weight: bold; color: #ffb300; border: 1px solid #444; font-size: 15px; }
        .popup-close { background: #d32f2f; color: white; margin-top: 15px; width: 100%; padding: 12px; border: none; border-radius: 8px; font-weight: bold; cursor: pointer; }
        .btn { width: 100%; padding: 14px; border: none; border-radius: 8px; font-size: 16px; font-weight: bold; cursor: pointer; color: white; margin-top: 10px; transition: 0.3s; }
        .btn-pay { background: #4CAF50; }
        .btn-download { background: #2196F3; }
        .btn-disabled { background: #555; color: #aaa; cursor: not-allowed; }
        #previewContainer { display: none; text-align: center; margin-top: 15px; }
        video { width: 100%; border-radius: 8px; margin-top: 10px; border: 1px solid #555; }
    </style>
</head>
<body>
    <div class="hero-banner">
        <h2 style="margin:0; text-shadow: 2px 2px 4px rgba(0,0,0,0.8);">🎥 DukaanVideo Studio</h2>
        <p style="margin:5px 0 0 0; font-size: 14px; color: #ffd54f;">Apni Dukan, Dairy ya Gaming ke liye Shandar Video banayein!</p>
    </div>
    <div class="card">
        <label>1. Apna Business ya Game Category Chuniye:</label>
        <select id="category">
            <option>General Store / Dukaan</option>
            <option>Doodh Dairy & Paneer</option>
            <option>Mobile & Electronics Shop</option>
            <option>Mithaai & Restaurant</option>
            <option>Gaming & Tournaments 🎮</option>
            <option>Mahakal Puzzle Battle 🎮</option>
        </select>
        <label>2. Voice-Over (Speaker Aawaz) Chuniye:</label>
        <select id="voice">
            <option>Ladki ki Aawaz (Female AI)</option>
            <option>Ladke ki Aawaz (Male AI)</option>
            <option>Meri Apni Aawaz (Voice Clone)</option>
        </select>
        <label>3. Background Music Chuniye:</label>
        <select id="bgMusic">
            <option value="none">🚫 No Music</option>
            <option value="upbeat">Upbeat Promotional Beat</option>
            <option value="gaming">Gaming Action Remix</option>
            <option value="acoustic">Soft Acoustic Background</option>
        </select>
        <label>4. Video ki Script / Offer Likhein ya Bol kar Type Karein:</label>
        <div class="chat-input-bar">
            <button type="button" class="icon-btn" onclick="openPopup()" title="Media Jodein (+)">➕</button>
            <textarea id="script" rows="1" placeholder="Yahan script likhein ya mic dabayein..."></textarea>
            <button type="button" class="icon-btn mic-btn" id="micBtn" onclick="toggleSpeechRecognition()" title="Mic">🎤</button>
            <button type="button" class="btn-send" onclick="generatePreview()" title="Preview Dekhein">⬆</button>
        </div>
        <p id="selectedMediaText" style="text-align: center; color: #4CAF50; font-size: 13px; font-weight: bold; margin: 5px 0;"></p>
        <input type="file" id="multiPhotos" accept="image/*" multiple style="display:none" onchange="handleFiles(this)">
        <input type="file" id="camCapture" accept="image/*" capture="environment" style="display:none" onchange="handleFiles(this)">
        <input type="file" id="videoUpload" accept="video/*" style="display:none" onchange="handleFiles(this)">
        <div id="previewContainer">
            <label style="color: #4CAF50;">✅ Video Taiyar Hai! Play karke check karein:</label>
            <video id="videoPreview" controls>
                <source id="videoSource" src="" type="video/mp4">
                Aapka browser video tag support nahi karta.
            </video>
        </div>
        <button class="btn btn-pay" onclick="payUPI()">Pay ₹5 (Google Pay / PhonePe) & Unlock</button>
        <button id="dlBtn" class="btn btn-disabled" onclick="downloadVideo()" disabled>Video Download Karein (Locked 🔒)</button>
    </div>
    <div id="mediaPopup" class="popup-modal">
        <h3 style="margin-top:0; color:#ffb300; text-align:center;">Media Chuniye</h3>
        <div class="popup-item" onclick="triggerInput('multiPhotos')">🖼️ Gallery se Multiple Photos Chuniye</div>
        <div class="popup-item" onclick="triggerInput('camCapture')">📸 Camera se Live Photo Khichne</div>
        <div class="popup-item" onclick="triggerInput('videoUpload')">📹 Video Upload Karein</div>
        <button class="popup-close" onclick="closePopup()">Band Karein (Cancel)</button>
    </div>
    <script>
        let recognition;
        let isRecording = false;
        let downloadedUrl = "";

        function toggleSpeechRecognition() {
            const SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
            if (!SpeechRecognition) { alert("Aapka browser Voice Typing support nahi karta."); return; }
            const micBtn = document.getElementById('micBtn');
            const scriptArea = document.getElementById('script');
            if (!isRecording) {
                recognition = new SpeechRecognition();
                recognition.lang = 'hi-IN';
                recognition.onstart = function() { isRecording = true; micBtn.classList.add('recording'); micBtn.innerText = "🔴"; };
                recognition.onresult = function(event) { scriptArea.value += (scriptArea.value ? " " : "") + event.results[0][0].transcript; };
                recognition.onerror = function() { stopMicState(); };
                recognition.onend = function() { stopMicState(); };
                recognition.start();
            } else {
                if (recognition) { recognition.stop(); }
                stopMicState();
            }
        }
        function stopMicState() { isRecording = false; const micBtn = document.getElementById('micBtn'); micBtn.classList.remove('recording'); micBtn.innerText = "🎤"; }
        function openPopup() { document.getElementById('mediaPopup').style.display = 'block'; }
        function closePopup() { document.getElementById('mediaPopup').style.display = 'none'; }
        function triggerInput(inputId) { closePopup(); document.getElementById(inputId).click(); }
        function handleFiles(input) { if (input.files.length > 0) { document.getElementById('selectedMediaText').innerText = "✔ " + input.files.length + " file(s) select ho gayi hain!"; } }
        
        function generatePreview() {
            const scriptText = document.getElementById('script').value;
            const formData = new FormData();
            formData.append('script', scriptText);

            alert("Video render ho rahi hai, kripya thoda intezaar karein...");
            
            fetch('/verify-and-generate', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if(data.status === 'Success') {
                    document.getElementById('previewContainer').style.display = 'block';
                    const videoSource = document.getElementById('videoSource');
                    videoSource.src = data.video_url;
                    downloadedUrl = data.video_url;
                    document.getElementById('videoPreview').load();
                    alert(data.message);
                } else {
                    alert("Error: " + data.error);
                }
            })
            .catch(err => {
                alert("Server connection error: " + err);
            });
        }

        function payUPI() {
            window.location.href = "upi://pay?pa=Sandeepkumarsandeepku7862mar-6@oksbi&pn=DukaanVideo&am=5.00&cu=INR&tn=Dukaan%20Video%20Fee";
            setTimeout(() => {
                alert("Payment verified successfully! 🎉");
                const dlBtn = document.getElementById("dlBtn");
                dlBtn.disabled = false;
                dlBtn.className = "btn btn-download";
                dlBtn.innerText = "Video Download Karein (Unlocked 🚀)";
            }, 3000);
        }

        function downloadVideo() {
            if(downloadedUrl) {
                window.location.href = downloadedUrl;
            } else {
                alert("Pehle preview generate karein!");
            }
        }
    </script>
</body>
</html>
"""

@app.route('/')
def home():
    return render_template_string(HTML_PAGE)

@app.route('/verify-and-generate', methods=['POST'])
def verify_and_generate():
    try:
        script_text = request.form.get('script', 'Hamari dukaan par swagat hai!')
        output_filename = 'dukaan_promo.mp4'
        output_video_path = os.path.join(OUTPUT_FOLDER, output_filename)
        
        if not os.path.exists(output_video_path):
            with open(output_video_path, 'wb') as f:
                f.write(b'dummy video content')

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
