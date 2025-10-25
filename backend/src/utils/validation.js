const Joi = require('joi');

/**
 * Validation schemas for authentication
 */

// Registration validation
const registerSchema = Joi.object({
  username: Joi.string()
    .pattern(/^[a-zA-Z0-9_]+$/)
    .min(3)
    .max(30)
    .required()
    .messages({
      'string.pattern.base': 'Username must only contain letters, numbers, and underscores',
      'string.min': 'Username must be at least 3 characters long',
      'string.max': 'Username must not exceed 30 characters',
      'any.required': 'Username is required',
    }),
  phoneNumber: Joi.string()
    .pattern(/^(\+233|0)[0-9]{9}$/)
    .required()
    .messages({
      'string.pattern.base': 'Phone number must be in format +233XXXXXXXXX or 0XXXXXXXXX',
      'any.required': 'Phone number is required',
    }),
  password: Joi.string()
    .min(8)
    .pattern(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]/)
    .required()
    .messages({
      'string.min': 'Password must be at least 8 characters long',
      'string.pattern.base': 'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
      'any.required': 'Password is required',
    }),
  fullName: Joi.string()
    .min(2)
    .max(100)
    .required()
    .messages({
      'string.min': 'Full name must be at least 2 characters long',
      'string.max': 'Full name must not exceed 100 characters',
      'any.required': 'Full name is required',
    }),
  userType: Joi.string()
    .valid('user', 'rider')
    .required()
    .messages({
      'any.only': 'User type must be either user or rider',
      'any.required': 'User type is required',
    }),
  email: Joi.string()
    .email()
    .optional()
    .allow('')
    .messages({
      'string.email': 'Please provide a valid email address',
    }),
});

// Login validation
const loginSchema = Joi.object({
  identifier: Joi.string()
    .required()
    .messages({
      'any.required': 'Username or phone number is required',
    }),
  password: Joi.string()
    .required()
    .messages({
      'any.required': 'Password is required',
    }),
});

// OTP verification validation
const verifyOTPSchema = Joi.object({
  phoneNumber: Joi.string()
    .pattern(/^(\+233|0)[0-9]{9}$/)
    .required()
    .messages({
      'string.pattern.base': 'Phone number must be in format +233XXXXXXXXX or 0XXXXXXXXX',
      'any.required': 'Phone number is required',
    }),
  otpCode: Joi.string()
    .length(6)
    .pattern(/^[0-9]+$/)
    .required()
    .messages({
      'string.length': 'OTP must be 6 digits',
      'string.pattern.base': 'OTP must contain only numbers',
      'any.required': 'OTP code is required',
    }),
  purpose: Joi.string()
    .valid('registration', 'login', 'transaction', 'password_reset')
    .required()
    .messages({
      'any.only': 'Invalid OTP purpose',
      'any.required': 'OTP purpose is required',
    }),
});

// Resend OTP validation
const resendOTPSchema = Joi.object({
  phoneNumber: Joi.string()
    .pattern(/^(\+233|0)[0-9]{9}$/)
    .required()
    .messages({
      'string.pattern.base': 'Phone number must be in format +233XXXXXXXXX or 0XXXXXXXXX',
      'any.required': 'Phone number is required',
    }),
  purpose: Joi.string()
    .valid('registration', 'login', 'transaction', 'password_reset')
    .required()
    .messages({
      'any.only': 'Invalid OTP purpose',
      'any.required': 'OTP purpose is required',
    }),
});

// Profile update validation
const updateProfileSchema = Joi.object({
  fullName: Joi.string()
    .min(2)
    .max(100)
    .optional()
    .messages({
      'string.min': 'Full name must be at least 2 characters long',
      'string.max': 'Full name must not exceed 100 characters',
    }),
  email: Joi.string()
    .email()
    .optional()
    .allow('')
    .messages({
      'string.email': 'Please provide a valid email address',
    }),
});

module.exports = {
  registerSchema,
  loginSchema,
  verifyOTPSchema,
  resendOTPSchema,
  updateProfileSchema,
};
