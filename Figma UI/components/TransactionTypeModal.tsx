import { motion, AnimatePresence } from "motion/react";
import { ShoppingCart, Store, X } from "lucide-react";
import { Card } from "./ui/card";

interface TransactionTypeModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSelect: (type: "buy" | "sell") => void;
}

export function TransactionTypeModal({ isOpen, onClose, onSelect }: TransactionTypeModalProps) {
  return (
    <AnimatePresence>
      {isOpen && (
        <>
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 0.4 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 bg-black z-40"
            onClick={onClose}
          />
          <motion.div
            initial={{ y: "100%" }}
            animate={{ y: 0 }}
            exit={{ y: "100%" }}
            transition={{ type: "spring", damping: 30, stiffness: 300 }}
            className="fixed bottom-0 left-0 right-0 bg-white rounded-t-[32px] z-50 p-6"
          >
            <div className="max-w-md mx-auto">
              <div className="flex justify-between items-center mb-6">
                <h2>Create Transaction</h2>
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  onClick={onClose}
                  className="p-2 hover:bg-gray-100 rounded-full"
                >
                  <X className="w-5 h-5" />
                </motion.button>
              </div>

              <p className="text-gray-500 mb-6">Choose whether you want to buy or sell</p>

              <div className="space-y-4 mb-6">
                <motion.div
                  whileHover={{ scale: 1.02, boxShadow: "0 10px 40px rgba(10, 87, 230, 0.2)" }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => {
                    onSelect("buy");
                    onClose();
                  }}
                >
                  <Card className="p-6 cursor-pointer hover:border-[#043b69] transition-all">
                    <div className="flex items-center gap-4">
                      <div className="p-3 bg-blue-100 rounded-xl">
                        <ShoppingCart className="w-8 h-8 text-[#043b69]" />
                      </div>
                      <div className="flex-1">
                        <h3>Buy</h3>
                        <p className="text-gray-500 text-sm">I want to purchase something</p>
                      </div>
                    </div>
                  </Card>
                </motion.div>

                <motion.div
                  whileHover={{ scale: 1.02, boxShadow: "0 10px 40px rgba(16, 185, 129, 0.2)" }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => {
                    onSelect("sell");
                    onClose();
                  }}
                >
                  <Card className="p-6 cursor-pointer hover:border-green-600 transition-all">
                    <div className="flex items-center gap-4">
                      <div className="p-3 bg-green-100 rounded-xl">
                        <Store className="w-8 h-8 text-green-600" />
                      </div>
                      <div className="flex-1">
                        <h3>Sell</h3>
                        <p className="text-gray-500 text-sm">I want to sell a product or service</p>
                      </div>
                    </div>
                  </Card>
                </motion.div>
              </div>
            </div>
          </motion.div>
        </>
      )}
    </AnimatePresence>
  );
}
