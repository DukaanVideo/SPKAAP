const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Import modules
const db = require('./database');
const paymentRouter = require('./PaymentLock');
const earningRouter = require('./EarningTracker');
const { sendTelegramAlert } = require('./TelegramBot');
const { renderPromotionalVideo } = require('./VideoEngine');

// Middleware to handle JSON and Form Data
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// Serve frontend public folder
app.use(express.static('public'));

// Use API Routes
app.use('/api', paymentRouter);
app.use('/api', earningRouter);

// Main Home Route
app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

// API Endpoint to Receive User Script & Photos for Video Generation
app.post('/api/generate-video', async (req, res) => {
    try {
        const { mobile, scriptText, category, photos } = req.body;
        
        if (!scriptText) {
            return res.status(400).json({ success: false, message: 'Script text is required!' });
        }

        console.log(`[REQUEST] User: ${mobile} | Category: ${category} | Script Length: ${scriptText.length}`);

        // Video Engine / Worker ko trigger karna
        const videoResult = await renderPromotionalVideo(scriptText, category, photos);

        res.status(200).json({
            success: true,
            message: 'Video rendering started successfully on your server!',
            downloadFee: 5.00,
            unlockStatus: false,
            videoData: videoResult
        });

    } catch (error) {
        console.error(error);
        res.status(500).json({ success: false, message: 'Server Error during video generation' });
    }
});

// Start the Server
app.listen(PORT, () => {
    console.log(`🚀 Khatarnak Server is live on port ${PORT}`);
});
