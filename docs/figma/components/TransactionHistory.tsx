import { motion } from "motion/react";
import { ArrowLeft, Filter, Search, X } from "lucide-react";
import { Card } from "./ui/card";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { useState } from "react";

interface TransactionHistoryProps {
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function TransactionHistory({ onBack, onNavigate }: TransactionHistoryProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [filterStatus, setFilterStatus] = useState<string>("all");
  const [showFilters, setShowFilters] = useState(false);

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
      description: "Brand new MacBook Pro 14-inch with M3 chip",
      escrowFee: "8.50",
      expectedDelivery: "Nov 2, 2025"
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
      description: "Complete website redesign and development",
      escrowFee: "12.00",
      expectedDelivery: "Oct 27, 2025"
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
      description: "PlayStation 5 with 2 controllers and 3 games",
      escrowFee: "4.50",
      expectedDelivery: "Oct 30, 2025"
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
      description: "Complete branding package with logo design",
      escrowFee: "25.00",
      expectedDelivery: "Oct 25, 2025"
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
      description: "Canon DSLR camera with lenses",
      escrowFee: "6.80",
      expectedDelivery: "Oct 28, 2025"
    },
    { 
      id: "ESC-45818", 
      date: "Oct 23, 2025", 
      amount: "1,800.00", 
      name: "iPhone 15 Pro Max", 
      counterparty: "Lisa Anderson",
      status: "Completed", 
      role: "seller",
      category: "Physical Product",
      description: "256GB, Natural Titanium, Excellent condition",
      escrowFee: "18.00",
      expectedDelivery: "Oct 23, 2025"
    },
    { 
      id: "ESC-45817", 
      date: "Oct 22, 2025", 
      amount: "3,200.00", 
      name: "E-commerce Website", 
      counterparty: "David Park",
      status: "Completed", 
      role: "seller",
      category: "Service",
      description: "Full e-commerce platform with payment integration",
      escrowFee: "32.00",
      expectedDelivery: "Oct 22, 2025"
    },
    { 
      id: "ESC-45816", 
      date: "Oct 21, 2025", 
      amount: "920.00", 
      name: "Office Furniture Set", 
      counterparty: "Jennifer Lee",
      status: "Cancelled", 
      role: "buyer",
      category: "Physical Product",
      description: "Executive desk and ergonomic chair",
      escrowFee: "9.20",
      expectedDelivery: "Oct 25, 2025"
    },
    { 
      id: "ESC-45815", 
      date: "Oct 20, 2025", 
      amount: "1,500.00", 
      name: "Digital Marketing Course", 
      counterparty: "Mark Thompson",
      status: "Completed", 
      role: "buyer",
      category: "Digital Good",
      description: "Complete digital marketing masterclass",
      escrowFee: "15.00",
      expectedDelivery: "Oct 20, 2025"
    },
    { 
      id: "ESC-45814", 
      date: "Oct 19, 2025", 
      amount: "750.00", 
      name: "Smart Watch Collection", 
      counterparty: "Anna Garcia",
      status: "Completed", 
      role: "seller",
      category: "Physical Product",
      description: "3 premium smartwatches in excellent condition",
      escrowFee: "7.50",
      expectedDelivery: "Oct 19, 2025"
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

  const filterOptions = [
    { value: "all", label: "All" },
    { value: "in escrow", label: "In Escrow" },
    { value: "completed", label: "Completed" },
    { value: "in progress", label: "In Progress" },
    { value: "disputed", label: "Disputed" },
    { value: "cancelled", label: "Cancelled" },
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
      case "cancelled":
        return "bg-gray-100 text-gray-700 border-gray-200";
      default:
        return "bg-gray-100 text-gray-700 border-gray-200";
    }
  };

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6"
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center justify-between gap-4 mb-4">
            <div className="flex items-center gap-4">
              <motion.button
                whileTap={{ scale: 0.9 }}
                onClick={onBack}
                className="p-2 hover:bg-white/10"
              >
                <ArrowLeft className="w-5 h-5" />
              </motion.button>
              <div>
                <h2>Transaction History</h2>
                <p className="text-xs opacity-80">{allTransactions.length} total transactions</p>
              </div>
            </div>
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={() => setShowFilters(!showFilters)}
              className={`p-2 hover:bg-white/10 ${showFilters ? "bg-white/10" : ""}`}
            >
              <Filter className="w-5 h-5" />
            </motion.button>
          </div>

          {/* Search Bar */}
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              placeholder="Search transactions..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-10 bg-white/10 border-white/20 text-white placeholder:text-white/60"
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-white/60 hover:text-white"
              >
                <X className="w-5 h-5" />
              </button>
            )}
          </div>

          {/* Filters */}
          {showFilters && (
            <motion.div
              initial={{ opacity: 0, height: 0 }}
              animate={{ opacity: 1, height: "auto" }}
              exit={{ opacity: 0, height: 0 }}
              className="flex gap-2 flex-wrap mt-3"
            >
              {filterOptions.map((option) => (
                <motion.button
                  key={option.value}
                  whileTap={{ scale: 0.95 }}
                  onClick={() => {
                    setFilterStatus(option.value);
                    setShowFilters(false);
                  }}
                  className={`px-3 py-1.5 text-sm transition-colors ${
                    filterStatus === option.value
                      ? "bg-white text-[#043b69]"
                      : "bg-white/20 text-white hover:bg-white/30"
                  }`}
                >
                  {option.label}
                </motion.button>
              ))}
            </motion.div>
          )}
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-4">
        {filteredTransactions.length === 0 ? (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center py-12"
          >
            <h3 className="mb-2">No transactions found</h3>
            <p className="text-gray-500">
              {searchQuery ? "Try adjusting your search or filters" : "No transactions available"}
            </p>
          </motion.div>
        ) : (
          filteredTransactions.map((transaction, index) => (
            <motion.div
              key={transaction.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              whileTap={{ scale: 0.98 }}
            >
              <Card 
                className="p-4 shadow-sm hover:shadow-md transition-all cursor-pointer"
                onClick={() => onNavigate("transaction-details", transaction)}
              >
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <p className="text-xs text-gray-500 mb-1">{transaction.id}</p>
                    <p className="text-xs text-gray-400">{transaction.date}</p>
                  </div>
                  <Badge className={`${getStatusColor(transaction.status)} border`}>
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
                    className="text-[#043b69] border-[#043b69] hover:bg-blue-50"
                    onClick={(e) => {
                      e.stopPropagation();
                      onNavigate("transaction-details", transaction);
                    }}
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
  );
}
