import { motion } from "motion/react";
import { ArrowLeft, Upload, DollarSign } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Textarea } from "./ui/textarea";
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from "./ui/select";
import { useState } from "react";

interface CreateTransactionProps {
  transactionType: "buy" | "sell";
  onBack: () => void;
  onSubmit: (data: any) => void;
}

export function CreateTransaction({ transactionType, onBack, onSubmit }: CreateTransactionProps) {
  const [formData, setFormData] = useState({
    title: "",
    category: "product",
    counterpartyEmail: "",
    amount: "",
    description: "",
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    // Navigate to PIN confirmation before creating escrow
    onSubmit({ 
      ...formData, 
      transactionType,
      requiresPin: true 
    });
  };

  const isBuying = transactionType === "buy";

  return (
    <div className="h-screen bg-[#F9FAFB] dark:bg-gray-900 pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-5 sm:p-6 z-10"
      >
        <div className="flex items-center gap-3 sm:gap-4 max-w-md mx-auto">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={onBack}
            className="p-2 hover:bg-white/10"
          >
            <ArrowLeft className="w-5 h-5" />
          </motion.button>
          <div>
            <h2>{isBuying ? "Buy" : "Sell"} Transaction</h2>
            <p className="text-xs opacity-80">
              {isBuying ? "You're purchasing something" : "You're selling something"}
            </p>
          </div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.1 }}
          >
            <Label>
              {isBuying ? "What are you buying?" : "What are you selling?"}
            </Label>
            <Input
              placeholder={isBuying ? "e.g., iPhone 15 Pro" : "e.g., iPhone 15 Pro Sale"}
              value={formData.title}
              onChange={(e) => setFormData({ ...formData, title: e.target.value })}
              className="mt-2"
            />
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.2 }}
          >
            <Label>Category</Label>
            <Select value={formData.category} onValueChange={(value) => setFormData({ ...formData, category: value })}>
              <SelectTrigger className="mt-2">
                <SelectValue />
              </SelectTrigger>
              <SelectContent>
                <SelectItem value="product">Physical Product</SelectItem>
                <SelectItem value="service">Service</SelectItem>
                <SelectItem value="digital">Digital Good</SelectItem>
                <SelectItem value="other">Other</SelectItem>
              </SelectContent>
            </Select>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.3 }}
          >
            <Label>
              {isBuying ? "Seller Username/Phone" : "Buyer Username/Phone"}
            </Label>
            <Input
              type="text"
              placeholder={isBuying ? "@username or +1234567890" : "@username or +1234567890"}
              value={formData.counterpartyEmail}
              onChange={(e) => setFormData({ ...formData, counterpartyEmail: e.target.value })}
              className="mt-2"
            />
            <p className="text-xs text-gray-500 mt-1">
              {isBuying 
                ? "Enter the username or phone number of the seller"
                : "Enter the username or phone number of the buyer"}
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.4 }}
          >
            <Label>Amount (USD)</Label>
            <div className="relative mt-2">
              <DollarSign className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <Input
                type="number"
                placeholder="0.00"
                value={formData.amount}
                onChange={(e) => setFormData({ ...formData, amount: e.target.value })}
                className="pl-10"
              />
            </div>
            <p className="text-xs text-gray-500 mt-1">
              {isBuying 
                ? "This amount will be held in escrow until you confirm receipt"
                : "You'll receive this amount once the buyer confirms receipt"}
            </p>
          </motion.div>

          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            transition={{ delay: 0.5 }}
          >
            <Label>Description</Label>
            <Textarea
              placeholder={isBuying 
                ? "Describe what you're purchasing..."
                : "Describe what you're selling..."}
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              className="mt-2 min-h-[100px]"
            />
          </motion.div>

          {!isBuying && (
            <motion.div
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              transition={{ delay: 0.6 }}
            >
              <Label>Upload Images (Optional)</Label>
              <motion.div
                whileHover={{ scale: 1.01 }}
                whileTap={{ scale: 0.99 }}
                className="mt-2 border-2 border-dashed border-gray-300 p-8 text-center cursor-pointer hover:border-[#043b69] transition-colors"
              >
                <Upload className="w-8 h-8 mx-auto mb-2 text-gray-400" />
                <p className="text-gray-500">Click to upload or drag and drop</p>
                <p className="text-xs text-gray-400 mt-1">PNG, JPG up to 10MB</p>
              </motion.div>
            </motion.div>
          )}

          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.7 }}
          >
            <Button
              type="submit"
              className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg"
              disabled={!formData.title || !formData.counterpartyEmail || !formData.amount || !formData.description}
            >
              {isBuying ? "Create Escrow Transaction" : "Create Escrow Listing"}
            </Button>
          </motion.div>
        </form>
      </div>
    </div>
  );
}
