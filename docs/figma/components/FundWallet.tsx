import { motion } from "motion/react";
import { ArrowLeft, CreditCard, Smartphone, Building2, DollarSign } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { useState } from "react";
import { toast } from "sonner@2.0.3";

interface FundWalletProps {
  onBack: () => void;
  onNavigate?: (screen: string, data?: any) => void;
  kycStatus?: string;
}

export function FundWallet({ onBack, onNavigate, kycStatus = "pending" }: FundWalletProps) {
  const [selectedMethod, setSelectedMethod] = useState<string | null>(null);
  const [amount, setAmount] = useState("");

  const paymentMethods = [
    { id: "card", name: "Card Payment", icon: CreditCard, color: "blue" },
    { id: "mobile", name: "Mobile Money", icon: Smartphone, color: "green" },
    { id: "bank", name: "Bank Transfer", icon: Building2, color: "purple" },
  ];

  const handlePayment = () => {
    // Check KYC status first
    if (kycStatus !== "verified") {
      toast.error("KYC Verification Required", {
        description: "Please complete KYC verification to fund your wallet"
      });
      if (onNavigate) {
        onNavigate("kyc-verification");
      }
      return;
    }
    
    if (onNavigate && amount && selectedMethod) {
      onNavigate("pin-confirmation", {
        action: "deposit",
        transaction: { 
          amount: amount,
          method: selectedMethod,
          type: "deposit"
        }
      });
    }
  };

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
          <h2>Fund Wallet</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        {/* Amount Input */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
          className="mb-6"
        >
          <Label>Amount to Add</Label>
          <div className="relative mt-2">
            <DollarSign className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              type="number"
              placeholder="0.00"
              value={amount}
              onChange={(e) => setAmount(e.target.value)}
              className="pl-10 text-2xl h-14"
            />
          </div>
        </motion.div>

        {/* Payment Methods */}
        <div className="mb-6">
          <h4 className="mb-4">Select Payment Method</h4>
          <div className="space-y-3">
            {paymentMethods.map((method, index) => {
              const Icon = method.icon;
              const isSelected = selectedMethod === method.id;
              
              return (
                <motion.div
                  key={method.id}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.2 + index * 0.1 }}
                  whileHover={{ scale: 1.02 }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => setSelectedMethod(method.id)}
                >
                  <Card className={`p-4 cursor-pointer transition-all ${
                    isSelected ? "border-2 border-[#043b69] shadow-lg" : "border shadow-sm"
                  }`}>
                    <div className="flex items-center gap-3">
                      <div className={`p-3 rounded-xl ${
                        method.color === "blue" ? "bg-blue-100" :
                        method.color === "green" ? "bg-green-100" :
                        "bg-purple-100"
                      }`}>
                        <Icon className={`w-6 h-6 ${
                          method.color === "blue" ? "text-blue-600" :
                          method.color === "green" ? "text-green-600" :
                          "text-purple-600"
                        }`} />
                      </div>
                      <div className="flex-1">{method.name}</div>
                      <div className={`w-5 h-5 rounded-full border-2 ${
                        isSelected ? "border-[#043b69] bg-[#043b69]" : "border-gray-300"
                      } flex items-center justify-center`}>
                        {isSelected && (
                          <motion.div
                            initial={{ scale: 0 }}
                            animate={{ scale: 1 }}
                            className="w-2 h-2 bg-white rounded-full"
                          />
                        )}
                      </div>
                    </div>
                  </Card>
                </motion.div>
              );
            })}
          </div>
        </div>

        {/* Payment Details Form */}
        {selectedMethod && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            transition={{ type: "spring", stiffness: 200 }}
            className="space-y-4 mb-6"
          >
            {selectedMethod === "card" && (
              <>
                <div>
                  <Label>Card Number</Label>
                  <Input placeholder="1234 5678 9012 3456" className="mt-2" />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div>
                    <Label>Expiry Date</Label>
                    <Input placeholder="MM/YY" className="mt-2" />
                  </div>
                  <div>
                    <Label>CVV</Label>
                    <Input placeholder="123" type="password" className="mt-2" />
                  </div>
                </div>
              </>
            )}
            {selectedMethod === "mobile" && (
              <div>
                <Label>Phone Number</Label>
                <Input placeholder="+1 (234) 567-8900" className="mt-2" />
              </div>
            )}
            {selectedMethod === "bank" && (
              <>
                <div>
                  <Label>Account Number</Label>
                  <Input placeholder="1234567890" className="mt-2" />
                </div>
                <div>
                  <Label>Routing Number</Label>
                  <Input placeholder="123456789" className="mt-2" />
                </div>
              </>
            )}
          </motion.div>
        )}

        {/* Confirm Button */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <Button
            onClick={handlePayment}
            disabled={!amount || !selectedMethod}
            className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg disabled:opacity-50"
          >
            Confirm Payment
          </Button>
        </motion.div>
      </div>
    </div>
  );
}
