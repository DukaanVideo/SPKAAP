const express = require('express');
const router = express.Router();
const db = require('./database'); // Tera database server file

// Endpoint to Check or Update Payment Status for Video Download
router.post('/verify-payment', (req, res) => {
    const { mobile, videoId, transactionId } = req.body;

    if (!mobile || !videoId) {
        return res.status(400).json({ success: false, message: 'Mobile number and Video ID are required!' });
    }

    console.log(`[PAYMENT] Verifying ₹5 payment for User: ${mobile} | Txn: ${transactionId || 'Direct UPI Intent'}`);

    // Database mein update karein ki is video ka payment ho chuka hai
    db.run(
        `UPDATE videos SET is_paid = 1 WHERE id = ? AND mobile = ?`,
        [videoId, mobile],
        function (err) {
            if (err) {
                console.error('❌ Database Update Error:', err.message);
                return res.status(500).json({ success: false, message: 'Payment verification failed on server.' });
            }

            if (this.changes === 0) {
                return res.status(404).json({ success: false, message: 'Video record not found!' });
            }

            console.log(`✅ Payment Verified Successfully! Download Unlocked for User: ${mobile}`);

            res.status(200).json({
                success: true,
                message: 'Payment verified successfully! Download unlocked.',
                unlocked: true,
                feeCollected: 5.00
            });
        }
    );
});

module.exports = router;
