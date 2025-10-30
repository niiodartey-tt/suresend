import { motion } from "motion/react";
import { Bell, Layers, CheckCircle, AlertTriangle, Award, Filter, Search, X } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { Input } from "./ui/input";
import { Badge } from "./ui/badge";
import { useState } from "react";
import { useTheme } from "./ThemeContext";
import { useNotificationService } from "./NotificationService";

interface DashboardProps {
  onNavigate: (screen: string, data?: any) => void;
}

export function Dashboard({ onNavigate }: DashboardProps) {
  const { isDark } = useTheme();
  const { notifications, transactions } = useNotificationService();
  const [showFilters, setShowFilters] = useState(false);
  const [filterStatus, setFilterStatus] = useState<string>("all");
  const [searchQuery, setSearchQuery] = useState("");
  
  const unreadNotifications = notifications.filter(n => !n.read).length;
  
  const stats = [
    { label: "Active", value: String(transactions.filter(t => t.status === "In Escrow" || t.status === "In Progress").length), icon: Layers, color: "text-blue-600", bgColor: "bg-blue-50 dark:bg-blue-900/20" },
    { label: "Completed", value: String(transactions.filter(t => t.status === "Completed").length), icon: CheckCircle, color: "text-green-600", bgColor: "bg-green-50 dark:bg-green-900/20" },
    { label: "Dispute", value: "1", icon: AlertTriangle, color: "text-orange-600", bgColor: "bg-orange-50 dark:bg-orange-900/20" },
    { label: "Total", value: String(transactions.length), icon: Award, color: "text-purple-600", bgColor: "bg-purple-50 dark:bg-purple-900/20" },
  ];

  const allTransactions = [
    { 
      id: "ESC-45823", 
      date: "Oct 28, 2025", 
      amount: "850.00", 
      name: "MacBook Pro M3", 
      counterparty: "Sarah Johnson",
      status: "In Escrow", 
      role: "buyer",
      category: "Physical Product",
      description: "Brand new MacBook Pro 14-inch with M3 chip"
    },
    { 
      id: "ESC-45822", 
      date: "Oct 27, 2025", 
      amount: "1,200.00", 
      name: "Web Development Service", 
      counterparty: "James Miller",
      status: "Completed", 
      role: "seller",
      category: "Service",
      description: "Complete website redesign and development"
    },
    { 
      id: "ESC-45821", 
      date: "Oct 26, 2025", 
      amount: "450.00", 
      name: "Gaming Console Bundle", 
      counterparty: "Mike Davis",
      status: "In Progress", 
      role: "seller",
      category: "Physical Product",
      description: "PlayStation 5 with 2 controllers and 3 games"
    },
    { 
      id: "ESC-45820", 
      date: "Oct 25, 2025", 
      amount: "2,500.00", 
      name: "Graphic Design Package", 
      counterparty: "Emma Wilson",
      status: "Completed", 
      role: "buyer",
      category: "Service",
      description: "Complete branding package with logo design"
    },
    { 
      id: "ESC-45819", 
      date: "Oct 24, 2025", 
      amount: "680.00", 
      name: "Camera Equipment", 
      counterparty: "Robert Chen",
      status: "Disputed", 
      role: "buyer",
      category: "Physical Product",
      description: "Canon DSLR camera with lenses"
    }
  ];
  
  const filteredTransactions = allTransactions.filter((transaction) => {
    const matchesSearch = 
      transaction.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      transaction.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
      transaction.counterparty.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesFilter = 
      filterStatus === "all" || 
      transaction.status.toLowerCase() === filterStatus.toLowerCase();
    
    return matchesSearch && matchesFilter;
  });
  
  const recentTransactions = filteredTransactions.slice(0, 3);
  
  const filterOptions = [
    { value: "all", label: "All" },
    { value: "in escrow", label: "In Escrow" },
    { value: "completed", label: "Completed" },
    { value: "in progress", label: "In Progress" },
    { value: "disputed", label: "Disputed" },
  ];
  
  const getStatusColor = (status: string) => {
    switch (status.toLowerCase()) {
      case "completed":
        return "bg-green-100 text-green-700 border-green-200";
      case "in escrow":
        return "bg-blue-100 text-blue-700 border-blue-200";
      case "in progress":
        return "bg-yellow-100 text-yellow-700 border-yellow-200";
      case "disputed":
        return "bg-red-100 text-red-700 border-red-200";
      default:
        return "bg-gray-100 text-gray-700 border-gray-200";
    }
  };

  return (
    <div className={`h-screen pb-24 overflow-y-auto ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'}`}>
      {/* Header with Wallet Balance */}
      <div className="relative">
        <motion.div
          initial={{ opacity: 0, y: -20 }}
          animate={{ opacity: 1, y: 0 }}
          className={`p-6 pb-24 text-white ${isDark ? 'bg-gradient-to-br from-gray-800 to-gray-900' : 'bg-gradient-to-br from-[#043b69] to-[#032d51]'}`}
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
              {unreadNotifications > 0 && (
                <motion.div
                  initial={{ scale: 0 }}
                  animate={{ scale: 1 }}
                  transition={{ type: "spring", stiffness: 500 }}
                  className="absolute -top-1 -right-1 bg-red-500 text-white rounded-full w-5 h-5 flex items-center justify-center text-xs"
                >
                  {unreadNotifications}
                </motion.div>
              )}
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
            <p className="text-xs text-gray-500">October</p>
          </div>
          <div className="flex items-center gap-3">
            <motion.button 
              whileTap={{ scale: 0.9 }}
              onClick={() => setShowFilters(!showFilters)}
              className={`p-2 hover:bg-gray-100 ${showFilters ? "bg-gray-100" : ""}`}
            >
              <Filter className="w-5 h-5 text-gray-600" />
            </motion.button>
            <button 
              onClick={() => onNavigate("transaction-history")}
              className="text-[#043b69] text-sm hover:underline"
            >
              See all
            </button>
          </div>
        </div>
        
        {/* Search and Filter */}
        {showFilters && (
          <motion.div
            initial={{ opacity: 0, height: 0 }}
            animate={{ opacity: 1, height: "auto" }}
            exit={{ opacity: 0, height: 0 }}
            className="mb-4 space-y-3"
          >
            <div className="relative">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
              <Input
                placeholder="Search transactions..."
                value={searchQuery}
                onChange={(e) => setSearchQuery(e.target.value)}
                className="pl-10 pr-10 bg-white"
              />
              {searchQuery && (
                <button
                  onClick={() => setSearchQuery("")}
                  className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                >
                  <X className="w-5 h-5" />
                </button>
              )}
            </div>
            
            <div className="flex gap-2 flex-wrap">
              {filterOptions.map((option) => (
                <motion.button
                  key={option.value}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => setFilterStatus(option.value)}
                  className={`px-3 py-1.5 text-sm transition-colors ${
                    filterStatus === option.value
                      ? "bg-[#043b69] text-white"
                      : "bg-white text-gray-700 border hover:bg-gray-50"
                  }`}
                >
                  {option.label}
                </motion.button>
              ))}
            </div>
          </motion.div>
        )}

        <div className="space-y-4">
          {recentTransactions.length === 0 ? (
            <motion.div
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              className="text-center py-8"
            >
              <p className="text-gray-500">No transactions found</p>
              <p className="text-sm text-gray-400">Try adjusting your filters</p>
            </motion.div>
          ) : (
            recentTransactions.map((transaction, index) => (
              <motion.div
                key={transaction.id}
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                transition={{ delay: 0.2 + index * 0.1 }}
                whileTap={{ scale: 0.98 }}
              >
                <Card className="p-4 shadow-sm hover:shadow-md transition-all cursor-pointer" onClick={() => onNavigate("transaction-details", transaction)}>
                  <div className="flex justify-between items-start mb-3">
                    <div>
                      <p className="text-xs text-gray-500 mb-1">{transaction.id}</p>
                      <p className="text-xs text-gray-400">{transaction.date}</p>
                    </div>
                    <Badge className={`${getStatusColor(transaction.status)} border text-xs`}>
                      {transaction.status}
                    </Badge>
                  </div>
                  <div className="flex justify-between items-end">
                    <div>
                      <div className="mb-2">${transaction.amount}</div>
                      <p className="text-sm text-gray-600 mb-1">{transaction.name}</p>
                      <p className="text-xs text-gray-400">
                        {transaction.role === "buyer" ? "Seller: " : "Buyer: "}
                        {transaction.counterparty}
                      </p>
                    </div>
                    <Button
                      size="sm"
                      variant="outline"
                      onClick={(e) => {
                        e.stopPropagation();
                        onNavigate("transaction-details", transaction);
                      }}
                      className="text-[#043b69] border-[#043b69] hover:bg-blue-50"
                    >
                      Details
                    </Button>
                  </div>
                </Card>
              </motion.div>
            ))
          )}
        </div>
      </div>
    </div>
  );
}
