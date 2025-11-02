import { motion } from "motion/react";
import { Mail, Lock, Eye, EyeOff, Fingerprint } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Checkbox } from "./ui/checkbox";
import { useState } from "react";
import { OTPVerification } from "./OTPVerification";
import { useBiometric } from "./BiometricService";
import { toast } from "sonner@2.0.3";

interface LoginScreenProps {
  onLogin: () => void;
  onNavigate: (screen: string) => void;
}

export function LoginScreen({ onLogin, onNavigate }: LoginScreenProps) {
  const [showPassword, setShowPassword] = useState(false);
  const [showOTPModal, setShowOTPModal] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    password: "",
    rememberMe: false,
  });
  const { isAvailable: biometricAvailable, isEnrolled: biometricEnrolled, authenticate } = useBiometric();

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // After password validation, show OTP modal
    setShowOTPModal(true);
  };

  const handleOTPVerify = () => {
    setShowOTPModal(false);
    onLogin();
  };

  const handleBiometricLogin = async () => {
    try {
      const success = await authenticate();
      if (success) {
        toast.success("Biometric authentication successful!");
        onLogin();
      } else {
        toast.error("Biometric authentication failed");
      }
    } catch (error) {
      toast.error("Biometric authentication failed");
    }
  };

  return (
    <div className="h-screen bg-[#F9FAFB] dark:bg-gray-900 overflow-y-auto">
      {/* Header */}
      <div className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6 sm:p-8 pb-12 sm:pb-16">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="max-w-md mx-auto"
        >
          <h1 className="text-2xl sm:text-3xl mb-2">Welcome Back</h1>
          <p className="text-sm opacity-80">Sign in to continue</p>
        </motion.div>
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
                  value={formData.email}
                  onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                  className="pl-10"
                  required
                />
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.3 }}
            >
              <Label htmlFor="password">Password</Label>
              <div className="relative mt-2">
                <Lock className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
                <Input
                  id="password"
                  type={showPassword ? "text" : "password"}
                  placeholder="••••••••"
                  value={formData.password}
                  onChange={(e) => setFormData({ ...formData, password: e.target.value })}
                  className="pl-10 pr-10"
                  required
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  {showPassword ? <EyeOff className="w-5 h-5" /> : <Eye className="w-5 h-5" />}
                </button>
              </div>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.4 }}
              className="flex items-center justify-between"
            >
              <div className="flex items-center gap-2">
                <Checkbox
                  id="remember"
                  checked={formData.rememberMe}
                  onCheckedChange={(checked) => 
                    setFormData({ ...formData, rememberMe: checked as boolean })
                  }
                />
                <label htmlFor="remember" className="text-sm text-gray-600 cursor-pointer">
                  Remember me
                </label>
              </div>
              <button
                type="button"
                onClick={() => onNavigate("forgot-password")}
                className="text-sm text-[#043b69] hover:underline"
              >
                Forgot Password?
              </button>
            </motion.div>

            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.5 }}
            >
              <Button
                type="submit"
                className="w-full bg-[#043b69] hover:bg-[#032d51] h-11 sm:h-12"
              >
                Sign In
              </Button>
            </motion.div>

            {/* Biometric Login */}
            {biometricAvailable && biometricEnrolled && (
              <motion.div
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.55 }}
                className="relative"
              >
                <div className="relative flex items-center justify-center my-4">
                  <div className="border-t border-gray-200 dark:border-gray-700 w-full absolute"></div>
                  <span className="bg-white dark:bg-gray-800 px-3 text-xs text-gray-500 dark:text-gray-400 relative">
                    OR
                  </span>
                </div>
                <Button
                  type="button"
                  variant="outline"
                  onClick={handleBiometricLogin}
                  className="w-full h-11 sm:h-12 flex items-center justify-center gap-2"
                >
                  <Fingerprint className="w-5 h-5" />
                  Sign in with Biometrics
                </Button>
              </motion.div>
            )}
          </form>
        </motion.div>

        {/* Sign Up Link */}
        <motion.div
          initial={{ opacity: 0 }}
          animate={{ opacity: 1 }}
          transition={{ delay: 0.6 }}
          className="text-center mt-6 mb-8"
        >
          <p className="text-gray-600 dark:text-gray-400 text-sm sm:text-base">
            Don't have an account?{" "}
            <button
              onClick={() => onNavigate("signup")}
              className="text-[#043b69] dark:text-blue-400 hover:underline"
            >
              Sign Up
            </button>
          </p>
        </motion.div>
      </div>

      {/* OTP Verification Modal */}
      <OTPVerification
        isOpen={showOTPModal}
        onClose={() => setShowOTPModal(false)}
        onVerify={handleOTPVerify}
        email={formData.email}
      />
    </div>
  );
}
