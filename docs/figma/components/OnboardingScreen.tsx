import { motion, AnimatePresence } from "motion/react";
import { Shield, Lock, Zap, ArrowRight } from "lucide-react";
import { Button } from "./ui/button";
import { useState } from "react";

interface OnboardingScreenProps {
  onComplete: () => void;
}

const slides = [
  {
    icon: Shield,
    title: "Secure Escrow",
    description: "Your funds are protected in secure escrow until both parties confirm the transaction",
    color: "#043b69",
  },
  {
    icon: Lock,
    title: "Safe & Encrypted",
    description: "Bank-level encryption and security measures to keep your money and data safe",
    color: "#10B981",
  },
  {
    icon: Zap,
    title: "Fast Transactions",
    description: "Quick and easy transactions with real-time updates and instant notifications",
    color: "#F59E0B",
  },
];

export function OnboardingScreen({ onComplete }: OnboardingScreenProps) {
  const [currentSlide, setCurrentSlide] = useState(0);

  const handleNext = () => {
    if (currentSlide < slides.length - 1) {
      setCurrentSlide(currentSlide + 1);
    } else {
      onComplete();
    }
  };

  const handleSkip = () => {
    onComplete();
  };

  return (
    <div className="h-screen bg-[#F9FAFB] dark:bg-gray-900 flex flex-col">
      {/* Skip Button */}
      <div className="flex justify-end p-4 sm:p-6">
        <motion.button
          whileTap={{ scale: 0.95 }}
          onClick={handleSkip}
          className="text-gray-500 dark:text-gray-400 hover:text-gray-700 dark:hover:text-gray-300 text-sm sm:text-base"
        >
          Skip
        </motion.button>
      </div>

      {/* Content */}
      <div className="flex-1 flex flex-col items-center justify-center px-4 sm:px-6 py-8">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentSlide}
            initial={{ opacity: 0, x: 50 }}
            animate={{ opacity: 1, x: 0 }}
            exit={{ opacity: 0, x: -50 }}
            transition={{ duration: 0.3 }}
            className="text-center max-w-md w-full"
          >
            {/* Icon */}
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ type: "spring", stiffness: 200, delay: 0.1 }}
              className="mb-6 sm:mb-8"
            >
              <div
                className="w-20 h-20 sm:w-24 sm:h-24 mx-auto flex items-center justify-center"
                style={{ backgroundColor: `${slides[currentSlide].color}20` }}
              >
                {(() => {
                  const Icon = slides[currentSlide].icon;
                  return (
                    <Icon
                      className="w-10 h-10 sm:w-12 sm:h-12"
                      style={{ color: slides[currentSlide].color }}
                    />
                  );
                })()}
              </div>
            </motion.div>

            {/* Title */}
            <motion.h2
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 }}
              className="mb-3 sm:mb-4 dark:text-white text-xl sm:text-2xl"
            >
              {slides[currentSlide].title}
            </motion.h2>

            {/* Description */}
            <motion.p
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="text-gray-600 dark:text-gray-400 mb-6 sm:mb-8 text-sm sm:text-base px-2"
            >
              {slides[currentSlide].description}
            </motion.p>
          </motion.div>
        </AnimatePresence>
      </div>

      {/* Navigation */}
      <div className="p-4 sm:p-6 pb-6 sm:pb-8">
        <div className="max-w-md mx-auto">
          {/* Dots */}
          <div className="flex justify-center gap-2 mb-5 sm:mb-6">
            {slides.map((_, index) => (
              <motion.div
                key={index}
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ delay: index * 0.1 }}
                className={`h-2 transition-all ${
                  index === currentSlide
                    ? "w-8 bg-[#043b69] dark:bg-blue-400"
                    : "w-2 bg-gray-300 dark:bg-gray-600"
                }`}
              />
            ))}
          </div>

          {/* Next Button */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
          >
            <Button
              onClick={handleNext}
              className="w-full bg-[#043b69] hover:bg-[#032d51] h-11 sm:h-12 gap-2"
            >
              {currentSlide < slides.length - 1 ? "Next" : "Get Started"}
              <ArrowRight className="w-4 h-4" />
            </Button>
          </motion.div>
        </div>
      </div>
    </div>
  );
}
