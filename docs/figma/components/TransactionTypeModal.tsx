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
            className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 rounded-t-[24px] sm:rounded-t-[32px] z-50 p-5 sm:p-6 pb-8 sm:pb-6"
          >
            <div className="max-w-md mx-auto">
              <div className="flex justify-between items-center mb-5 sm:mb-6">
                <h2 className="dark:text-white">Create Transaction</h2>
                <motion.button
                  whileTap={{ scale: 0.9 }}
                  onClick={onClose}
                  className="p-2 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-full"
                >
                  <X className="w-5 h-5 dark:text-gray-200" />
                </motion.button>
              </div>

              <p className="text-gray-500 dark:text-gray-400 mb-5 sm:mb-6 text-sm sm:text-base">Choose whether you want to buy or sell</p>

              <div className="space-y-3 sm:space-y-4 mb-4 sm:mb-6">
                <motion.div
                  whileHover={{ scale: 1.02, boxShadow: "0 10px 40px rgba(10, 87, 230, 0.2)" }}
                  whileTap={{ scale: 0.98 }}
                  onClick={() => {
                    onSelect("buy");
                    onClose();
                  }}
                >
                  <Card className="p-5 sm:p-6 cursor-pointer hover:border-[#043b69] dark:hover:border-blue-400 transition-all dark:bg-gray-700">
                    <div className="flex items-center gap-3 sm:gap-4">
                      <div className="p-2.5 sm:p-3 bg-blue-100 dark:bg-blue-900/30 rounded-xl">
                        <ShoppingCart className="w-6 h-6 sm:w-8 sm:h-8 text-[#043b69] dark:text-blue-400" />
                      </div>
                      <div className="flex-1">
                        <h3 className="dark:text-white">Buy</h3>
                        <p className="text-gray-500 dark:text-gray-400 text-sm">I want to purchase something</p>
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
                  <Card className="p-5 sm:p-6 cursor-pointer hover:border-green-600 dark:hover:border-green-400 transition-all dark:bg-gray-700">
                    <div className="flex items-center gap-3 sm:gap-4">
                      <div className="p-2.5 sm:p-3 bg-green-100 dark:bg-green-900/30 rounded-xl">
                        <Store className="w-6 h-6 sm:w-8 sm:h-8 text-green-600 dark:text-green-400" />
                      </div>
                      <div className="flex-1">
                        <h3 className="dark:text-white">Sell</h3>
                        <p className="text-gray-500 dark:text-gray-400 text-sm">I want to sell a product or service</p>
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
