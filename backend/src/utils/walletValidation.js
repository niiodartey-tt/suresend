const Joi = require('joi');

// Fund wallet validation
const fundWalletSchema = Joi.object({
  amount: Joi.number()
    .positive()
    .min(10)
    .max(10000)
    .required()
    .messages({
      'number.base': 'Amount must be a number',
      'number.positive': 'Amount must be positive',
      'number.min': 'Minimum deposit is GHS 10.00',
      'number.max': 'Maximum deposit is GHS 10,000.00',
      'any.required': 'Amount is required',
    }),
  paymentMethod: Joi.string()
    .valid('paystack', 'mobile_money')
    .required()
    .messages({
      'any.only': 'Payment method must be paystack or mobile_money',
      'any.required': 'Payment method is required',
    }),
});

// Withdraw funds validation
const withdrawFundsSchema = Joi.object({
  amount: Joi.number()
    .positive()
    .min(50)
    .required()
    .messages({
      'number.base': 'Amount must be a number',
      'number.positive': 'Amount must be positive',
      'number.min': 'Minimum withdrawal is GHS 50.00',
      'any.required': 'Amount is required',
    }),
  withdrawalMethod: Joi.string()
    .valid('bank_transfer', 'mobile_money')
    .required()
    .messages({
      'any.only': 'Withdrawal method must be bank_transfer or mobile_money',
      'any.required': 'Withdrawal method is required',
    }),
  accountDetails: Joi.object({
    accountNumber: Joi.string().when('$withdrawalMethod', {
      is: 'bank_transfer',
      then: Joi.required(),
    }),
    bankName: Joi.string().when('$withdrawalMethod', {
      is: 'bank_transfer',
      then: Joi.required(),
    }),
    accountName: Joi.string().required(),
    mobileNumber: Joi.string().when('$withdrawalMethod', {
      is: 'mobile_money',
      then: Joi.required(),
    }),
    network: Joi.string()
      .valid('mtn', 'vodafone', 'airteltigo')
      .when('$withdrawalMethod', {
        is: 'mobile_money',
        then: Joi.required(),
      }),
  }).required(),
});

// Transfer funds validation
const transferFundsSchema = Joi.object({
  recipientUsername: Joi.string()
    .min(3)
    .max(30)
    .pattern(/^[a-zA-Z0-9_]+$/)
    .required()
    .messages({
      'string.pattern.base': 'Username must contain only letters, numbers, and underscores',
      'string.min': 'Username must be at least 3 characters',
      'string.max': 'Username must not exceed 30 characters',
      'any.required': 'Recipient username is required',
    }),
  amount: Joi.number()
    .positive()
    .min(1)
    .required()
    .messages({
      'number.base': 'Amount must be a number',
      'number.positive': 'Amount must be positive',
      'number.min': 'Minimum transfer is GHS 1.00',
      'any.required': 'Amount is required',
    }),
  description: Joi.string()
    .max(200)
    .optional()
    .messages({
      'string.max': 'Description must not exceed 200 characters',
    }),
});

// Validation middleware
const validate = (schema) => {
  return (req, res, next) => {
    const { error } = schema.validate(req.body, {
      abortEarly: false,
      context: { withdrawalMethod: req.body.withdrawalMethod },
    });

    if (error) {
      const errors = error.details.map((detail) => detail.message);
      return res.status(400).json({
        status: 'error',
        message: 'Validation failed',
        errors,
      });
    }

    next();
  };
};

module.exports = {
  validate,
  fundWalletSchema,
  withdrawFundsSchema,
  transferFundsSchema,
};
