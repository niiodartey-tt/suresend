import { motion, AnimatePresence } from "motion/react";
import { X, Lock } from "lucide-react";
import { Button } from "./ui/button";
import { useState, useRef, useEffect } from "react";
import { InputOTP, InputOTPGroup, InputOTPSlot } from "./ui/input-otp";

interface PinConfirmationProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: (pin: string) => void;
  action: string;
  transaction?: any;
}

export function PinConfirmation({ isOpen, onClose, onConfirm, action, transaction }: PinConfirmationProps) {
  const [pin, setPin] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);

  const handleConfirm = async () => {
    if (pin.length !== 4) {
      setError("Please enter a 4-digit PIN");
      return;
    }

    setLoading(true);
    setError("");
    
    // Simulate validation
    setTimeout(() => {
      if (pin === "1234") {
        onConfirm(pin);
        setPin("");
        setLoading(false);
      } else {
        setError("Incorrect PIN. Please try again.");
        setPin("");
        setLoading(false);
      }
    }, 800);
  };

  const handlePinChange = (value: string) => {
    setPin(value);
    setError("");
    
    // Auto-submit when 4 digits are entered
    if (value.length === 4) {
      setTimeout(() => {
        handleConfirm();
      }, 200);
    }
  };

  const actionText = {
    release: "Release Funds",
    withdraw: "Withdraw Funds",
    transfer: "Transfer Funds",
    "create-escrow": "Create Escrow Transaction",
    default: "Confirm Action"
  }[action] || "Confirm Action";

  return (
    <AnimatePresence>
      {isOpen && (
        <>
          {/* Backdrop */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            onClick={onClose}
            className="fixed inset-0 bg-black/60 z-50 backdrop-blur-sm"
          />

          {/* Modal */}
          <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
            <motion.div
              initial={{ opacity: 0, scale: 0.9, y: 20 }}
              animate={{ opacity: 1, scale: 1, y: 0 }}
              exit={{ opacity: 0, scale: 0.9, y: 20 }}
              transition={{ type: "spring", stiffness: 300, damping: 30 }}
              className="bg-white w-full max-w-md shadow-2xl relative"
              onClick={(e) => e.stopPropagation()}
            >
              {/* Close button */}
              <button
                onClick={onClose}
                className="absolute top-4 right-4 p-2 hover:bg-gray-100 transition-colors z-10"
              >
                <X className="w-5 h-5" />
              </button>

              {/* Header */}
              <div className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6 pb-12">
                <div className="flex items-center gap-3 mb-3">
                  <div className="w-12 h-12 bg-white/20 flex items-center justify-center">
                    <Lock className="w-6 h-6" />
                  </div>
                  <div>
                    <h3>Confirm Transaction</h3>
                    <p className="text-xs opacity-80">Enter your PIN to continue</p>
                  </div>
                </div>
              </div>

              {/* Content */}
              <div className="p-6 -mt-6">
                {/* Transaction Summary Card */}
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.1 }}
                  className="bg-white shadow-lg p-4 mb-6 border border-gray-100"
                >
                  <p className="text-xs text-gray-500 mb-2">Action</p>
                  <div className="mb-3">{actionText}</div>
                  {transaction && (
                    <>
                      <div className="border-t border-gray-200 pt-3 mt-3">
                        <p className="text-xs text-gray-500 mb-1">Amount</p>
                        <div className="text-2xl">${transaction.amount}</div>
                      </div>
                      <div className="mt-3">
                        <p className="text-xs text-gray-500 mb-1">Transaction ID</p>
                        <div className="text-sm text-gray-700">{transaction.id}</div>
                      </div>
                    </>
                  )}
                </motion.div>

                {/* PIN Input */}
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.2 }}
                  className="mb-6"
                >
                  <label className="block text-sm mb-3 text-center">
                    Enter 4-Digit PIN
                  </label>
                  <div className="flex justify-center">
                    <InputOTP
                      maxLength={4}
                      value={pin}
                      onChange={handlePinChange}
                      disabled={loading}
                    >
                      <InputOTPGroup>
                        <InputOTPSlot index={0} className="w-14 h-14 text-xl" />
                        <InputOTPSlot index={1} className="w-14 h-14 text-xl" />
                        <InputOTPSlot index={2} className="w-14 h-14 text-xl" />
                        <InputOTPSlot index={3} className="w-14 h-14 text-xl" />
                      </InputOTPGroup>
                    </InputOTP>
                  </div>
                  
                  {error && (
                    <motion.p
                      initial={{ opacity: 0, y: -10 }}
                      animate={{ opacity: 1, y: 0 }}
                      className="text-red-600 text-sm text-center mt-3"
                    >
                      {error}
                    </motion.p>
                  )}

                  <p className="text-xs text-gray-400 text-center mt-4">
                    For demo purposes, use PIN: 1234
                  </p>
                </motion.div>

                {/* Actions */}
                <motion.div
                  initial={{ opacity: 0, y: 10 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: 0.3 }}
                  className="space-y-3"
                >
                  <Button
                    onClick={handleConfirm}
                    disabled={pin.length !== 4 || loading}
                    className="w-full bg-[#043b69] hover:bg-[#032d51] h-12 disabled:opacity-50"
                  >
                    {loading ? "Verifying..." : "Confirm"}
                  </Button>
                  <Button
                    onClick={onClose}
                    variant="outline"
                    className="w-full h-12"
                    disabled={loading}
                  >
                    Cancel
                  </Button>
                </motion.div>
              </div>
            </motion.div>
          </div>
        </>
      )}
    </AnimatePresence>
  );
}
