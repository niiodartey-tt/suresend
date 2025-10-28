import { motion } from "motion/react";
import { ArrowLeft, Filter, Plus, Package, Handshake } from "lucide-react";
import { Card } from "./ui/card";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";

interface DealsScreenProps {
  onBack: () => void;
  onCreateDeal: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function DealsScreen({ onBack, onCreateDeal, onNavigate }: DealsScreenProps) {
  const deals = [
    {
      id: "ESC-10234",
      title: "iPhone 15 Pro",
      type: "product",
      amount: 450,
      status: "In Escrow",
      counterparty: "Alice Smith",
      role: "seller",
      date: "Oct 24, 2025",
    },
    {
      id: "ESC-10233",
      title: "MacBook Pro",
      type: "product",
      amount: 1200,
      status: "Completed",
      counterparty: "Bob Johnson",
      role: "buyer",
      date: "Oct 22, 2025",
    },
    {
      id: "ESC-10232",
      title: "Web Design Service",
      type: "service",
      amount: 350,
      status: "In Progress",
      counterparty: "Carol White",
      role: "seller",
      date: "Oct 20, 2025",
    },
    {
      id: "ESC-10231",
      title: "Logo Design",
      type: "service",
      amount: 200,
      status: "Pending",
      counterparty: "David Brown",
      role: "buyer",
      date: "Oct 18, 2025",
    },
  ];

  const getStatusColor = (status: string) => {
    switch (status) {
      case "Completed":
        return "bg-green-100 text-green-700";
      case "In Escrow":
        return "bg-blue-100 text-blue-700";
      case "In Progress":
        return "bg-yellow-100 text-yellow-700";
      case "Pending":
        return "bg-gray-100 text-gray-700";
      default:
        return "bg-gray-100 text-gray-700";
    }
  };

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="sticky top-0 bg-white border-b border-gray-200 p-4 z-10"
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center justify-between mb-4">
            <div className="flex items-center gap-4">
              <motion.button
                whileTap={{ scale: 0.9 }}
                onClick={onBack}
                className="p-2 hover:bg-gray-100 rounded-full"
              >
                <ArrowLeft className="w-5 h-5" />
              </motion.button>
              <h2>My Deals</h2>
            </div>
            <motion.button
              whileTap={{ scale: 0.9, rotate: 90 }}
              className="p-2 hover:bg-gray-100 rounded-full"
            >
              <Filter className="w-5 h-5" />
            </motion.button>
          </div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        <div className="space-y-4">
          {deals.map((deal, index) => (
            <motion.div
              key={deal.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.1 }}
              whileHover={{ y: -4, boxShadow: "0 10px 30px rgba(0,0,0,0.1)" }}
              whileTap={{ scale: 0.98 }}
              onClick={() => onNavigate("transaction-details", deal)}
            >
              <Card className={`p-4 cursor-pointer shadow-sm transition-shadow border-l-4 ${
                deal.role === "buyer" ? "border-l-blue-600" : "border-l-green-600"
              }`}>
                <div className="flex items-start gap-3 mb-3">
                  <div className={`p-2 rounded-lg ${
                    deal.role === "buyer" ? "bg-blue-100" : "bg-green-100"
                  }`}>
                    {deal.type === "product" ? (
                      <Package className={`w-5 h-5 ${
                        deal.role === "buyer" ? "text-blue-600" : "text-green-600"
                      }`} />
                    ) : (
                      <Handshake className={`w-5 h-5 ${
                        deal.role === "buyer" ? "text-blue-600" : "text-green-600"
                      }`} />
                    )}
                  </div>
                  <div className="flex-1">
                    <div className="flex justify-between items-start mb-1">
                      <div>
                        <div className="flex items-center gap-2">
                          <span>{deal.title}</span>
                          <span className={`text-xs px-2 py-0.5 rounded ${
                            deal.role === "buyer" 
                              ? "bg-blue-100 text-blue-700" 
                              : "bg-green-100 text-green-700"
                          }`}>
                            {deal.role === "buyer" ? "Buying" : "Selling"}
                          </span>
                        </div>
                        <p className="text-xs text-gray-500">{deal.id}</p>
                      </div>
                      <div className="text-right">
                        <div className={deal.role === "buyer" ? "text-red-600" : "text-green-600"}>
                          {deal.role === "buyer" ? "-" : "+"}${deal.amount}
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div className="flex justify-between items-center">
                  <div className="flex items-center gap-2">
                    <Badge className={getStatusColor(deal.status)}>
                      {deal.status}
                    </Badge>
                    <span className="text-xs text-gray-500">{deal.date}</span>
                  </div>
                  <p className="text-xs text-gray-500">
                    {deal.role === "buyer" ? "Seller" : "Buyer"}: {deal.counterparty}
                  </p>
                </div>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Floating Create Button */}
        <motion.button
          whileHover={{ scale: 1.1 }}
          whileTap={{ scale: 0.9 }}
          animate={{ y: [0, -10, 0] }}
          transition={{ y: { duration: 2, repeat: Infinity, ease: "easeInOut" } }}
          onClick={onCreateDeal}
          className="fixed bottom-24 right-6 bg-[#043b69] text-white p-4 rounded-full shadow-lg z-20"
        >
          <Plus className="w-6 h-6" />
        </motion.button>
      </div>
    </div>
  );
}
