const Joi = require('joi');

/**
 * Validation schemas for escrow and transactions
 */

// Create escrow transaction
const createEscrowSchema = Joi.object({
  sellerId: Joi.string()
    .uuid()
    .required()
    .messages({
      'string.uuid': 'Invalid seller ID format',
      'any.required': 'Seller ID is required',
    }),
  amount: Joi.number()
    .positive()
    .precision(2)
    .required()
    .messages({
      'number.positive': 'Amount must be greater than 0',
      'any.required': 'Amount is required',
    }),
  description: Joi.string()
    .min(5)
    .max(500)
    .required()
    .messages({
      'string.min': 'Description must be at least 5 characters',
      'string.max': 'Description must not exceed 500 characters',
      'any.required': 'Description is required',
    }),
  paymentMethod: Joi.string()
    .valid('wallet', 'momo', 'card')
    .required()
    .messages({
      'any.only': 'Payment method must be wallet, momo, or card',
      'any.required': 'Payment method is required',
    }),
  riderId: Joi.string()
    .uuid()
    .optional()
    .allow(null, '')
    .messages({
      'string.uuid': 'Invalid rider ID format',
    }),
});

// Confirm delivery
const confirmDeliverySchema = Joi.object({
  confirmed: Joi.boolean()
    .required()
    .messages({
      'any.required': 'Confirmation status is required',
    }),
  notes: Joi.string()
    .max(500)
    .optional()
    .allow('')
    .messages({
      'string.max': 'Notes must not exceed 500 characters',
    }),
});

// Raise dispute
const raiseDisputeSchema = Joi.object({
  reason: Joi.string()
    .min(10)
    .max(1000)
    .required()
    .messages({
      'string.min': 'Dispute reason must be at least 10 characters',
      'string.max': 'Dispute reason must not exceed 1000 characters',
      'any.required': 'Dispute reason is required',
    }),
});

// Cancel transaction
const cancelTransactionSchema = Joi.object({
  reason: Joi.string()
    .min(5)
    .max(500)
    .optional()
    .allow('')
    .messages({
      'string.min': 'Cancellation reason must be at least 5 characters',
      'string.max': 'Cancellation reason must not exceed 500 characters',
    }),
});

// Assign rider
const assignRiderSchema = Joi.object({
  riderId: Joi.string()
    .uuid()
    .required()
    .messages({
      'string.uuid': 'Invalid rider ID format',
      'any.required': 'Rider ID is required',
    }),
});

module.exports = {
  createEscrowSchema,
  confirmDeliverySchema,
  raiseDisputeSchema,
  cancelTransactionSchema,
  assignRiderSchema,
};
