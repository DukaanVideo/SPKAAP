const express = require('express');
const router = express.Router();
const db = require('./database'); // Tera database server file

// Endpoint to Get User Earning & Video History
router.get('/user-earnings/:mobile', (req, res) => {
    const mobile = req.params.mobile;

    console.log(`[EARNINGS] Fetching data for User: ${mobile}`);

    // Database se user ki paid videos aur total earnings nikalna
    db.all(
        `SELECT * FROM videos WHERE mobile = ? ORDER BY created_at DESC`,
        [mobile],
        (err, rows) => {
            if (err) {
                console.error('❌ Database Query Error:', err.message);
                return res.status(500).json({ success: false, message: 'Failed to fetch earning history.' });
            }

            // Total paid videos count calculate karna (Har paid video ka ₹5)
            const paidVideos = rows.filter(v => v.is_paid === 1);
            const totalEarned = paidVideos.length * 5;

            res.status(200).json({
                success: true,
                mobile: mobile,
                totalVideosCreated: rows.length,
                totalPaidDownloads: paidVideos.length,
                verifiedEarnings: totalEarned,
                history: rows
            });
        }
    );
});

module.exports = router;
