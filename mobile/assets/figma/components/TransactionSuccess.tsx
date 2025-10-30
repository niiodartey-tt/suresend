import { motion } from "motion/react";
import { CheckCircle, Download, Share2, Home } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { useEffect } from "react";

interface TransactionSuccessProps {
  transaction: any;
  action: string;
  onNavigate: (screen: string, data?: any) => void;
}

export function TransactionSuccess({ transaction, action, onNavigate }: TransactionSuccessProps) {
  // Confetti effect
  useEffect(() => {
    // Create simple particle effect
    const particles = 30;
    const container = document.getElementById('confetti-container');
    
    if (container) {
      for (let i = 0; i < particles; i++) {
        const particle = document.createElement('div');
        particle.className = 'confetti-particle';
        particle.style.left = Math.random() * 100 + '%';
        particle.style.animationDelay = Math.random() * 0.5 + 's';
        particle.style.backgroundColor = ['#043b69', '#10B981', '#F59E0B', '#EF4444'][Math.floor(Math.random() * 4)];
        container.appendChild(particle);
      }
    }

    return () => {
      if (container) {
        container.innerHTML = '';
      }
    };
  }, []);

  const successMessage = {
    release: "Funds Released Successfully",
    withdraw: "Withdrawal Successful",
    transfer: "Transfer Completed",
    payment: "Payment Successful",
    "create-escrow": "Escrow Created Successfully",
    default: "Transaction Successful"
  }[action] || "Transaction Successful";

  const successDescription = {
    release: "The funds have been released to the seller. Your transaction is now complete.",
    withdraw: "Your withdrawal request has been processed successfully.",
    transfer: "The funds have been transferred successfully.",
    payment: "Your payment has been processed successfully.",
    "create-escrow": "Your escrow transaction has been created successfully. Funds are now held securely until delivery confirmation.",
    default: "Your transaction has been completed successfully."
  }[action] || "Your transaction has been completed successfully.";

  return (
    <div className="h-screen bg-[#F9FAFB] relative overflow-hidden">
      {/* Confetti Container */}
      <div id="confetti-container" className="fixed inset-0 pointer-events-none z-10" />
      
      <style>{`
        .confetti-particle {
          position: absolute;
          width: 8px;
          height: 8px;
          top: -10px;
          animation: confetti-fall 3s ease-out forwards;
        }
        
        @keyframes confetti-fall {
          to {
            transform: translateY(100vh) rotate(360deg);
            opacity: 0;
          }
        }
      `}</style>

      {/* Background gradient circles */}
      <div className="absolute inset-0 overflow-hidden">
        <motion.div
          initial={{ scale: 0, opacity: 0 }}
          animate={{ scale: 1, opacity: 0.1 }}
          transition={{ duration: 1, ease: "easeOut" }}
          className="absolute top-1/4 left-1/2 -translate-x-1/2 -translate-y-1/2 w-96 h-96 bg-[#043b69] rounded-full blur-3xl"
        />
        <motion.div
          initial={{ scale: 0, opacity: 0 }}
          animate={{ scale: 1, opacity: 0.05 }}
          transition={{ duration: 1, delay: 0.2, ease: "easeOut" }}
          className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[500px] h-[500px] bg-green-500 rounded-full blur-3xl"
        />
      </div>

      {/* Content */}
      <div className="relative z-20 h-full flex flex-col items-center justify-center p-6">
        {/* Success Icon */}
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          transition={{ 
            type: "spring", 
            stiffness: 200, 
            damping: 15,
            delay: 0.1 
          }}
          className="mb-8"
        >
          <div className="relative">
            <motion.div
              initial={{ scale: 0.8, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              transition={{ delay: 0.3 }}
              className="absolute inset-0 bg-green-500/20 rounded-full blur-2xl"
            />
            <div className="relative w-24 h-24 bg-green-500 rounded-full flex items-center justify-center">
              <motion.div
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ 
                  type: "spring", 
                  stiffness: 300, 
                  damping: 20,
                  delay: 0.4 
                }}
              >
                <CheckCircle className="w-16 h-16 text-white" strokeWidth={2.5} />
              </motion.div>
            </div>
          </div>
        </motion.div>

        {/* Success Message */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="text-center mb-8"
        >
          <h2 className="mb-2">{successMessage}</h2>
          <p className="text-gray-500 max-w-sm">
            {successDescription}
          </p>
        </motion.div>

        {/* Transaction Details Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
          className="w-full max-w-md mb-8"
        >
          <Card className="p-6 shadow-lg">
            <div className="space-y-4">
              <div className="flex justify-between items-center pb-4 border-b border-gray-200">
                <span className="text-gray-500">Transaction ID</span>
                <span className="font-mono text-sm">{transaction?.id || "ESC-10234"}</span>
              </div>
              <div className="flex justify-between items-center pb-4 border-b border-gray-200">
                <span className="text-gray-500">Amount</span>
                <div className="text-2xl">${transaction?.amount || "450.00"}</div>
              </div>
              <div className="flex justify-between items-center pb-4 border-b border-gray-200">
                <span className="text-gray-500">Status</span>
                <span className={`px-3 py-1 text-sm ${
                  action === "create-escrow" 
                    ? "bg-blue-100 text-blue-700" 
                    : "bg-green-100 text-green-700"
                }`}>
                  {action === "create-escrow" ? "In Escrow" : "Completed"}
                </span>
              </div>
              <div className="flex justify-between items-center">
                <span className="text-gray-500">Date</span>
                <span className="text-sm">{new Date().toLocaleDateString('en-US', { 
                  month: 'short', 
                  day: 'numeric', 
                  year: 'numeric',
                  hour: '2-digit',
                  minute: '2-digit'
                })}</span>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Action Buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
          className="w-full max-w-md space-y-3"
        >
          {action === "create-escrow" ? (
            <Button
              onClick={() => onNavigate("transaction-details", transaction)}
              className="w-full bg-[#043b69] hover:bg-[#032d51] h-12"
            >
              View Transaction Details
            </Button>
          ) : (
            <Button
              onClick={() => onNavigate("dashboard")}
              className="w-full bg-[#043b69] hover:bg-[#032d51] h-12 gap-2"
            >
              <Home className="w-4 h-4" />
              Back to Dashboard
            </Button>
          )}
          
          <div className="grid grid-cols-2 gap-3">
            <Button
              variant="outline"
              className="h-12 gap-2"
              onClick={() => window.print()}
            >
              <Download className="w-4 h-4" />
              Download
            </Button>
            <Button
              variant="outline"
              className="h-12 gap-2"
              onClick={() => {
                if (navigator.share) {
                  navigator.share({
                    title: 'Transaction Receipt',
                    text: `Transaction ${transaction?.id} completed successfully!`
                  });
                }
              }}
            >
              <Share2 className="w-4 h-4" />
              Share
            </Button>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
