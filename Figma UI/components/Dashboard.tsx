import { motion } from "motion/react";
import { Bell, Layers, CheckCircle, AlertTriangle, Award, Filter, Search } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";

interface DashboardProps {
  onNavigate: (screen: string, data?: any) => void;
}

export function Dashboard({ onNavigate }: DashboardProps) {
  const stats = [
    { label: "Active", value: "1", icon: Layers, color: "text-blue-600", bgColor: "bg-blue-50" },
    { label: "Completed", value: "1", icon: CheckCircle, color: "text-green-600", bgColor: "bg-green-50" },
    { label: "Dispute", value: "1", icon: AlertTriangle, color: "text-orange-600", bgColor: "bg-orange-50" },
    { label: "Total", value: "1", icon: Award, color: "text-purple-600", bgColor: "bg-purple-50" },
  ];

  const recentTransactions = [
    { id: "ID: SD2342836", date: "Created on March,12 2023", amount: "1,200.00", name: "James Peter's enterprise", status: "In Escrow", role: "seller" },
    { id: "ID: SD2342836", date: "Created on March,12 2023", amount: "1,200.00", name: "James Peter's enterprise", status: "Completed", role: "buyer" },
    { id: "ID: SD2342836", date: "Created on March,12 2023", amount: "1,200.00", name: "James Peter's enterprise", status: "In Progress", role: "seller" },
  ];

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      {/* Header with Wallet Balance */}
      <div className="relative">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className="bg-gradient-to-br from-[#043b69] to-[#032d51] p-6 pb-24 text-white"
        >
          <div className="flex justify-between items-start mb-8">
            <div>
              <p className="text-white/80 text-sm mb-1">Welcome back,</p>
              <h2>John Doe</h2>
            </div>
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={() => onNavigate("notifications")}
              className="relative p-2 hover:bg-white/10"
            >
              <Bell className="w-6 h-6" />
              <motion.span
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                transition={{ type: "spring", stiffness: 500 }}
                className="absolute top-1 right-1 w-3 h-3 bg-red-500 border-2 border-white"
              />
            </motion.button>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <p className="text-white/80 text-sm mb-1">Wallet Balance</p>
              <motion.div 
                initial={{ scale: 0.9 }}
                animate={{ scale: 1 }}
                className="text-2xl"
              >
                $4,500.00
              </motion.div>
            </div>
            <div>
              <p className="text-white/80 text-sm mb-1">Escrow Balance</p>
              <div className="text-2xl">$200.00</div>
            </div>
          </div>
        </motion.div>

        {/* Stats Grid - Overlay */}
        <div className="px-6 -mt-16 relative z-10">
          <motion.div 
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="bg-white shadow-lg p-5"
          >
            <div className="grid grid-cols-2 gap-4">
              {stats.map((stat, index) => {
                const Icon = stat.icon;
                const isBottomRow = index >= 2;
                return (
                  <motion.div
                    key={stat.label}
                    initial={{ opacity: 0, scale: 0.9 }}
                    animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: index * 0.05, type: "spring" }}
                    whileTap={{ scale: 0.95 }}
                    className={`flex items-center gap-3 p-3 hover:bg-gray-50 transition-colors ${
                      isBottomRow ? 'border-t border-gray-200 pt-5' : ''
                    }`}
                  >
                    <div className={`p-2 ${stat.bgColor}`}>
                      <Icon className={`w-5 h-5 ${stat.color}`} />
                    </div>
                    <div>
                      <div className="text-sm text-gray-500">{stat.label}</div>
                      <div className="text-xl">{stat.value}</div>
                    </div>
                  </motion.div>
                );
              })}
            </div>
          </motion.div>
        </div>
      </div>

      {/* Action Buttons */}
      <div className="px-6 mb-8 mt-6 flex gap-3">
        <motion.div whileTap={{ scale: 0.98 }} className="flex-1">
          <Button
            onClick={() => onNavigate("wallet")}
            className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg h-12"
          >
            + Top up wallet
          </Button>
        </motion.div>
        <motion.div whileTap={{ scale: 0.98 }} className="flex-1">
          <Button
            onClick={() => onNavigate("withdraw")}
            className="w-full bg-black hover:bg-gray-900 text-white shadow-lg h-12"
          >
            Withdraw
          </Button>
        </motion.div>
      </div>

      {/* Recent Transactions */}
      <div className="px-6 pb-6">
        <div className="flex justify-between items-center mb-4">
          <div>
            <h3 className="uppercase tracking-wide text-sm">Recent Transactions</h3>
            <p className="text-xs text-gray-500">March</p>
          </div>
          <div className="flex items-center gap-3">
            <motion.button 
              whileTap={{ scale: 0.9 }}
              className="p-2 hover:bg-gray-100"
            >
              <Filter className="w-5 h-5 text-gray-600" />
            </motion.button>
            <motion.button 
              whileTap={{ scale: 0.9 }}
              className="p-2 hover:bg-gray-100"
            >
              <Search className="w-5 h-5 text-gray-600" />
            </motion.button>
            <button className="text-[#043b69] text-sm">See all</button>
          </div>
        </div>

        <div className="space-y-4">
          {recentTransactions.map((transaction, index) => (
            <motion.div
              key={`${transaction.id}-${index}`}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.2 + index * 0.1 }}
              whileTap={{ scale: 0.98 }}
            >
              <Card className="p-4 shadow-sm hover:shadow-md transition-all">
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <p className="text-xs text-gray-500 mb-1">{transaction.id}</p>
                    <p className="text-xs text-gray-400">{transaction.date}</p>
                  </div>
                </div>
                <div className="flex justify-between items-end">
                  <div>
                    <div className="mb-2">${transaction.amount}</div>
                    <p className="text-sm text-gray-600">{transaction.name}</p>
                  </div>
                  <Button
                    size="sm"
                    variant="outline"
                    onClick={() => onNavigate("transaction-details", transaction)}
                    className="text-[#043b69] border-[#043b69] hover:bg-blue-50"
                  >
                    See details
                  </Button>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>
      </div>
    </div>
  );
}
