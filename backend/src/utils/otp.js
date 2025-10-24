/**
 * Generate a random OTP code
 * @param {number} length - Length of OTP (default 6)
 * @returns {string} OTP code
 */
const generateOTP = (length = 6) => {
  const digits = '0123456789';
  let otp = '';
  for (let i = 0; i < length; i++) {
    otp += digits[Math.floor(Math.random() * 10)];
  }
  return otp;
};

/**
 * Calculate OTP expiry time
 * @param {number} minutes - Minutes until expiry (default 5)
 * @returns {Date} Expiry timestamp
 */
const getOTPExpiry = (minutes = 5) => {
  const expiry = new Date();
  expiry.setMinutes(expiry.getMinutes() + minutes);
  return expiry;
};

/**
 * Check if OTP is expired
 * @param {Date} expiryTime - OTP expiry timestamp
 * @returns {boolean} True if expired
 */
const isOTPExpired = (expiryTime) => {
  return new Date() > new Date(expiryTime);
};

/**
 * Send OTP via SMS (Development: Console log)
 * @param {string} phoneNumber - Recipient phone number
 * @param {string} otp - OTP code
 * @param {string} purpose - Purpose of OTP (registration, login, etc.)
 * @returns {Promise<object>} Result object
 */
const sendOTP = async (phoneNumber, otp, purpose = 'verification') => {
  // TODO: In production, integrate with Twilio or Firebase
  // For now, log to console for development
  console.log('\n========================================');
  console.log('📱 SMS OTP (Development Mode)');
  console.log('========================================');
  console.log(`To: ${phoneNumber}`);
  console.log(`Purpose: ${purpose}`);
  console.log(`OTP Code: ${otp}`);
  console.log(`Expires: ${getOTPExpiry()} (5 minutes)`);
  console.log('========================================\n');

  // Simulate successful SMS send
  return {
    success: true,
    message: 'OTP sent successfully (dev mode)',
  };
};

module.exports = {
  generateOTP,
  getOTPExpiry,
  isOTPExpired,
  sendOTP,
};
