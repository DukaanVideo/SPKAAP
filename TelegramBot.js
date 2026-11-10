const https = require('https');

// Function to Send Video Alert or Download Link via Telegram Bot
function sendTelegramAlert(chatId, botToken, messageText, videoUrl) {
    if (!botToken || !chatId) {
        console.log('⚠️ Telegram Bot Token or Chat ID is missing. Skipping notification.');
        return;
    }

    const text = encodeURIComponent(`${messageText}\n\n🔗 Download Link: ${videoUrl}`);
    const url = `https://api.telegram.org/bot${botToken}/sendMessage?chat_id=${chatId}&text=${text}`;

    https.get(url, (res) => {
        let data = '';
        res.on('data', (chunk) => {
            data += chunk;
        });
        res.on('end', () => {
            console.log('✅ Telegram Notification Sent Successfully:', JSON.parse(data).ok);
        });
    }).on('error', (err) => {
        console.error('❌ Error sending Telegram alert:', err.message);
    });
}

module.exports = { sendTelegramAlert };
