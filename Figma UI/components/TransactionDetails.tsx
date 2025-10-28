import { motion } from "motion/react";
import { ArrowLeft, MessageCircle, AlertTriangle, CheckCircle } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Badge } from "./ui/badge";
import { Progress } from "./ui/progress";

interface TransactionDetailsProps {
  transaction: any;
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function TransactionDetails({ transaction, onBack, onNavigate }: TransactionDetailsProps) {
  const steps = [
    { label: "Initiated", completed: true },
    { label: "In Escrow", completed: true },
    { label: "Delivered", completed: false },
    { label: "Completed", completed: false },
  ];

  const progressValue = (steps.filter(s => s.completed).length / steps.length) * 100;

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="sticky top-0 bg-white border-b border-gray-200 p-4 z-10"
      >
        <div className="flex items-center gap-4 max-w-md mx-auto">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={onBack}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <ArrowLeft className="w-5 h-5" />
          </motion.button>
          <h2>Transaction Details</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-4">
        {/* Transaction Info Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card className="p-6 shadow-md">
            <div className="flex justify-between items-start mb-4">
              <div>
                <p className="text-gray-500 text-sm">{transaction.id || "ESC-10234"}</p>
                <h3>{transaction.name || "iPhone 15 Pro"}</h3>
              </div>
              <Badge className="bg-blue-100 text-blue-700 hover:bg-blue-100">
                {transaction.status || "In Escrow"}
              </Badge>
            </div>
            <div className="text-3xl mb-2">${transaction.amount || 450}</div>
            <p className="text-gray-500 text-sm">{transaction.date || "Oct 24, 2025"}</p>
          </Card>
        </motion.div>

        {/* Progress */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Transaction Progress</h4>
            <Progress value={progressValue} className="mb-4" />
            <div className="space-y-3">
              {steps.map((step, index) => (
                <div key={index} className="flex items-center gap-3">
                  {step.completed ? (
                    <CheckCircle className="w-5 h-5 text-green-600" />
                  ) : (
                    <div className="w-5 h-5 rounded-full border-2 border-gray-300" />
                  )}
                  <span className={step.completed ? "text-gray-900" : "text-gray-400"}>
                    {step.label}
                  </span>
                </div>
              ))}
            </div>
          </Card>
        </motion.div>

        {/* Buyer/Seller Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
          whileHover={{ y: -2, boxShadow: "0 10px 30px rgba(0,0,0,0.1)" }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Participants</h4>
            <div className="space-y-4">
              <div className="flex items-center gap-3">
                <Avatar>
                  <AvatarFallback className="bg-blue-100 text-[#043b69]">JD</AvatarFallback>
                </Avatar>
                <div>
                  <div>John Doe</div>
                  <p className="text-sm text-gray-500">Seller</p>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <Avatar>
                  <AvatarFallback className="bg-green-100 text-green-700">AS</AvatarFallback>
                </Avatar>
                <div>
                  <div>Alice Smith</div>
                  <p className="text-sm text-gray-500">Buyer</p>
                </div>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="space-y-3"
        >
          <Button
            className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg"
            onClick={() => {}}
          >
            Release Funds
          </Button>
          <Button
            variant="outline"
            className="w-full border-2 border-red-600 text-red-600 hover:bg-red-50"
            onClick={() => {}}
          >
            <AlertTriangle className="w-4 h-4 mr-2" />
            Raise Dispute
          </Button>
        </motion.div>

        {/* Chat Button */}
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={() => onNavigate("chat", transaction)}
          className="fixed bottom-24 right-6 bg-[#043b69] text-white p-4 rounded-full shadow-lg z-20"
        >
          <MessageCircle className="w-6 h-6" />
        </motion.button>
      </div>
    </div>
  );
}
