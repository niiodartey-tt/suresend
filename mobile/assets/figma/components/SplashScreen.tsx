import { motion } from "motion/react";
import { Shield } from "lucide-react";

interface SplashScreenProps {
  onComplete: () => void;
}

export function SplashScreen({ onComplete }: SplashScreenProps) {
  return (
    <motion.div
      className="fixed inset-0 bg-gradient-to-b from-[#043b69] to-[#032d51] flex flex-col items-center justify-center"
      initial={{ opacity: 1 }}
      animate={{ opacity: 1 }}
      exit={{ opacity: 0, y: -50 }}
      transition={{ duration: 0.5 }}
      onAnimationComplete={() => {
        setTimeout(() => onComplete(), 2000);
      }}
    >
      <motion.div
        initial={{ scale: 0, opacity: 0 }}
        animate={{ scale: 1, opacity: 1 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="flex flex-col items-center gap-6"
      >
        <div className="bg-white/10 p-6 rounded-3xl backdrop-blur-sm">
          <Shield className="w-20 h-20 text-white" />
        </div>
        <div className="text-center">
          <h1 className="text-white mb-2">SecureEscrow</h1>
          <p className="text-white/70">Secure Escrow for Every Deal</p>
        </div>
      </motion.div>
    </motion.div>
  );
}
