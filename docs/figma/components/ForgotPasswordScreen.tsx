import { motion } from "motion/react";
import { ArrowLeft, Mail, CheckCircle } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { useState } from "react";

interface ForgotPasswordScreenProps {
  onBack: () => void;
  onNavigate: (screen: string) => void;
}

export function ForgotPasswordScreen({ onBack, onNavigate }: ForgotPasswordScreenProps) {
  const [email, setEmail] = useState("");
  const [isSubmitted, setIsSubmitted] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitted(true);
  };

  if (isSubmitted) {
    return (
      <div className="h-screen bg-[#F9FAFB] dark:bg-gray-900 flex items-center justify-center p-4 sm:p-6">
        <motion.div
          initial={{ opacity: 0, scale: 0.9 }}
          animate={{ opacity: 1, scale: 1 }}
          className="max-w-md w-full"
        >
          <div className="bg-white dark:bg-gray-800 shadow-lg p-6 sm:p-8 text-center">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: "spring", stiffness: 200, delay: 0.2 }}
              className="w-16 h-16 bg-green-100 dark:bg-green-900/20 rounded-full flex items-center justify-center mx-auto mb-4"
            >
              <CheckCircle className="w-8 h-8 text-green-600" />
            </motion.div>
            <h2 className="mb-2 dark:text-white">Check Your Email</h2>
            <p className="text-gray-600 dark:text-gray-400 mb-6 text-sm sm:text-base">
              We've sent a password reset link to <strong>{email}</strong>
            </p>
            <p className="text-sm text-gray-500 dark:text-gray-500 mb-6">
              Didn't receive the email? Check your spam folder or try again.
            </p>
            <Button
              onClick={onBack}
              className="w-full bg-[#043b69] hover:bg-[#032d51] h-11 sm:h-12"
            >
              Back to Login
            </Button>
          </div>
        </motion.div>
      </div>
    );
  }

  return (
    <div className="h-screen bg-[#F9FAFB] dark:bg-gray-900 overflow-y-auto">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-5 sm:p-6 pb-12 sm:pb-16">
        <div className="max-w-md mx-auto">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={onBack}
            className="p-2 hover:bg-white/10 mb-3 sm:mb-4"
          >
            <ArrowLeft className="w-5 h-5" />
          </motion.button>
          <motion.div
            initial={{ opacity: 0, y: -20 }}
            animate={{ opacity: 1, y: 0 }}
          >
            <h1 className="text-2xl sm:text-3xl mb-2">Forgot Password?</h1>
            <p className="text-sm opacity-80">
              No worries, we'll send you reset instructions
            </p>
          </motion.div>
        </div>
      </div>

      {/* Form Card */}
      <div className="max-w-md mx-auto px-4 sm:px-6 -mt-8">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="bg-white dark:bg-gray-800 shadow-lg p-5 sm:p-6"
        >
          <form onSubmit={handleSubmit} className="space-y-5">
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.2 }}
            >
              <Label htmlFor="email">Email Address</Label>
              <div className="relative mt-2">
                <Mail className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <Input
                  id="email"
                  type="email"
                  placeholder="your@email.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  className="pl-10"
                  required
                />
              </div>
              <p className="text-xs text-gray-500 mt-2">
                Enter the email associated with your account
              </p>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
            >
              <Button
                type="submit"
                className="w-full bg-[#043b69] hover:bg-[#032d51] h-11 sm:h-12"
              >
                Send Reset Link
              </Button>
            </motion.div>
          </form>
        </motion.div>

        {/* Back to Login */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.4 }}
          className="text-center mt-5 sm:mt-6 mb-6 sm:mb-8"
        >
          <button
            onClick={onBack}
            className="text-[#043b69] dark:text-blue-400 hover:underline text-sm sm:text-base"
          >
            ← Back to Login
          </button>
        </motion.div>
      </div>
    </div>
  );
}
