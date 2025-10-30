import { motion } from "motion/react";
import { ArrowLeft, ArrowUpRight, ArrowDownLeft, Wallet } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";

interface WalletScreenProps {
  onBack: () => void;
  onNavigate: (screen: string) => void;
}

export function WalletScreen({ onBack, onNavigate }: WalletScreenProps) {
  const transactions = [
    { id: 1, type: "credit", amount: 850, description: "Escrow Created - ESC-45823", date: "Oct 28, 2025", txId: "ESC-45823" },
    { id: 2, type: "credit", amount: 1200, description: "Transaction Completed - ESC-45822", date: "Oct 27, 2025", txId: "ESC-45822" },
    { id: 3, type: "debit", amount: 450, description: "Escrow Payment - ESC-45821", date: "Oct 26, 2025", txId: "ESC-45821" },
    { id: 4, type: "credit", amount: 2500, description: "Wallet Top Up", date: "Oct 25, 2025", txId: null },
    { id: 5, type: "debit", amount: 680, description: "Escrow Payment - ESC-45819", date: "Oct 24, 2025", txId: "ESC-45819" },
    { id: 6, type: "credit", amount: 1800, description: "Transaction Completed - ESC-45818", date: "Oct 23, 2025", txId: "ESC-45818" },
    { id: 7, type: "credit", amount: 3200, description: "Transaction Completed - ESC-45817", date: "Oct 22, 2025", txId: "ESC-45817" },
    { id: 8, type: "credit", amount: 1000, description: "Wallet Top Up", date: "Oct 21, 2025", txId: null },
    { id: 9, type: "credit", amount: 750, description: "Transaction Completed - ESC-45814", date: "Oct 19, 2025", txId: "ESC-45814" },
    { id: 10, type: "debit", amount: 500, description: "Withdrawal to Bank", date: "Oct 18, 2025", txId: null },
  ];

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
          <h2>Wallet</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        {/* Balance Card */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: "spring", stiffness: 200 }}
        >
          <Card className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6 shadow-xl mb-6">
            <div className="flex items-center gap-3 mb-6">
              <Wallet className="w-6 h-6" />
              <span>My Wallet</span>
            </div>
            <div className="mb-2 text-sm opacity-80">Available Balance</div>
            <div className="text-4xl mb-4">$4,500</div>
            <div className="flex justify-between items-center pt-4 border-t border-white/20">
              <div>
                <div className="text-sm opacity-80">Escrow Balance</div>
                <div className="text-xl">$200</div>
              </div>
              <div className="text-right">
                <div className="text-sm opacity-80">Total</div>
                <div className="text-xl">$4,700</div>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Action Buttons */}
        <div className="flex gap-3 mb-6">
          <motion.div whileTap={{ scale: 0.95 }} className="flex-1">
            <Button
              onClick={() => onNavigate("fund-wallet")}
              className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg"
            >
              Top Up Wallet
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.95 }} className="flex-1">
            <Button
              onClick={() => onNavigate("withdraw")}
              variant="outline"
              className="w-full border-2 shadow-md"
            >
              Withdraw Funds
            </Button>
          </motion.div>
        </div>

        {/* Transaction History */}
        <div className="mb-4">
          <h3>Transaction History</h3>
        </div>

        <div className="space-y-3">
          {transactions.map((transaction, index) => (
            <motion.div
              key={transaction.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1, type: "spring" }}
              whileHover={{ scale: 1.02 }}
            >
              <Card className="p-4 shadow-sm hover:shadow-md transition-shadow">
                <div className="flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className={`p-2 rounded-full ${
                      transaction.type === "credit" ? "bg-green-100" : "bg-red-100"
                    }`}>
                      {transaction.type === "credit" ? (
                        <ArrowDownLeft className="w-5 h-5 text-green-600" />
                      ) : (
                        <ArrowUpRight className="w-5 h-5 text-red-600" />
                      )}
                    </div>
                    <div>
                      <div>{transaction.description}</div>
                      <p className="text-sm text-gray-500">{transaction.date}</p>
                    </div>
                  </div>
                  <div className={`${
                    transaction.type === "credit" ? "text-green-600" : "text-red-600"
                  }`}>
                    {transaction.type === "credit" ? "+" : "-"}${transaction.amount}
                  </div>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
