import { motion, AnimatePresence } from "motion/react";
import { ArrowLeft, Filter, Plus, Package, Handshake, Search, X } from "lucide-react";
import { Card } from "./ui/card";
import { Badge } from "./ui/badge";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { useState } from "react";

interface DealsScreenProps {
  onBack: () => void;
  onCreateDeal: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function DealsScreen({ onBack, onCreateDeal, onNavigate }: DealsScreenProps) {
  const [searchQuery, setSearchQuery] = useState("");
  const [selectedFilter, setSelectedFilter] = useState<string>("all");
  const [showFilterMenu, setShowFilterMenu] = useState(false);

  const allDeals = [
    {
      id: "ESC-45823",
      title: "MacBook Pro M3",
      type: "product",
      amount: 850,
      status: "In Escrow",
      counterparty: "Sarah Johnson",
      role: "buyer",
      date: "Oct 28, 2025",
      category: "Physical Product",
      description: "Brand new MacBook Pro 14-inch with M3 chip"
    },
    {
      id: "ESC-45822",
      title: "Web Development Service",
      type: "service",
      amount: 1200,
      status: "Completed",
      counterparty: "James Miller",
      role: "seller",
      date: "Oct 27, 2025",
      category: "Service",
      description: "Complete website redesign and development"
    },
    {
      id: "ESC-45821",
      title: "Gaming Console Bundle",
      type: "product",
      amount: 450,
      status: "In Progress",
      counterparty: "Mike Davis",
      role: "seller",
      date: "Oct 26, 2025",
      category: "Physical Product",
      description: "PlayStation 5 with 2 controllers and 3 games"
    },
    {
      id: "ESC-45820",
      title: "Graphic Design Package",
      type: "service",
      amount: 2500,
      status: "Completed",
      counterparty: "Emma Wilson",
      role: "buyer",
      date: "Oct 25, 2025",
      category: "Service",
      description: "Complete branding package with logo design"
    },
    {
      id: "ESC-45819",
      title: "Camera Equipment",
      type: "product",
      amount: 680,
      status: "Disputed",
      counterparty: "Robert Chen",
      role: "buyer",
      date: "Oct 24, 2025",
      category: "Physical Product",
      description: "Canon DSLR camera with lenses"
    },
    {
      id: "ESC-45818",
      title: "iPhone 15 Pro Max",
      type: "product",
      amount: 1800,
      status: "Completed",
      counterparty: "Lisa Anderson",
      role: "seller",
      date: "Oct 23, 2025",
      category: "Physical Product",
      description: "256GB, Natural Titanium, Excellent condition"
    },
    {
      id: "ESC-45817",
      title: "E-commerce Website",
      type: "service",
      amount: 3200,
      status: "Completed",
      counterparty: "David Park",
      role: "seller",
      date: "Oct 22, 2025",
      category: "Service",
      description: "Full e-commerce platform with payment integration"
    },
    {
      id: "ESC-45816",
      title: "Office Furniture Set",
      type: "product",
      amount: 920,
      status: "Cancelled",
      counterparty: "Jennifer Lee",
      role: "buyer",
      date: "Oct 21, 2025",
      category: "Physical Product",
      description: "Executive desk and ergonomic chair"
    }
  ];

  // Filter and search deals
  const filteredDeals = allDeals.filter((deal) => {
    const matchesSearch = 
      deal.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      deal.id.toLowerCase().includes(searchQuery.toLowerCase()) ||
      deal.counterparty.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesFilter = 
      selectedFilter === "all" ||
      (selectedFilter === "buying" && deal.role === "buyer") ||
      (selectedFilter === "selling" && deal.role === "seller") ||
      (selectedFilter === "active" && ["In Escrow", "In Progress", "Pending"].includes(deal.status)) ||
      (selectedFilter === "completed" && deal.status === "Completed") ||
      (selectedFilter === "disputed" && deal.status === "Disputed");
    
    return matchesSearch && matchesFilter;
  });

  const filterOptions = [
    { value: "all", label: "All Deals", count: allDeals.length },
    { value: "buying", label: "Buying", count: allDeals.filter(d => d.role === "buyer").length },
    { value: "selling", label: "Selling", count: allDeals.filter(d => d.role === "seller").length },
    { value: "active", label: "Active", count: allDeals.filter(d => ["In Escrow", "In Progress", "Pending"].includes(d.status)).length },
    { value: "completed", label: "Completed", count: allDeals.filter(d => d.status === "Completed").length },
    { value: "disputed", label: "Disputed", count: allDeals.filter(d => d.status === "Disputed").length },
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
      case "Disputed":
        return "bg-red-100 text-red-700";
      case "Cancelled":
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
        className="sticky top-0 bg-white border-b border-gray-200 p-4 z-20"
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
              whileTap={{ scale: 0.9 }}
              onClick={() => setShowFilterMenu(!showFilterMenu)}
              className={`p-2 hover:bg-gray-100 rounded-full ${showFilterMenu ? "bg-gray-100" : ""}`}
            >
              <Filter className="w-5 h-5" />
            </motion.button>
          </div>

          {/* Search Bar */}
          <div className="relative mb-3">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              placeholder="Search deals..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-10"
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

          {/* Filter Menu */}
          <AnimatePresence>
            {showFilterMenu && (
              <motion.div
                initial={{ opacity: 0, height: 0 }}
                animate={{ opacity: 1, height: "auto" }}
                exit={{ opacity: 0, height: 0 }}
                className="overflow-hidden"
              >
                <div className="flex gap-2 flex-wrap pb-2">
                  {filterOptions.map((option) => (
                    <motion.button
                      key={option.value}
                      whileTap={{ scale: 0.95 }}
                      onClick={() => {
                        setSelectedFilter(option.value);
                        setShowFilterMenu(false);
                      }}
                      className={`px-3 py-1.5 text-sm transition-colors ${
                        selectedFilter === option.value
                          ? "bg-[#043b69] text-white"
                          : "bg-gray-100 text-gray-700 hover:bg-gray-200"
                      }`}
                    >
                      {option.label} ({option.count})
                    </motion.button>
                  ))}
                </div>
              </motion.div>
            )}
          </AnimatePresence>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        {filteredDeals.length === 0 ? (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center py-12"
          >
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Package className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="mb-2">No deals found</h3>
            <p className="text-gray-500 mb-6">
              {searchQuery 
                ? "Try adjusting your search or filters" 
                : "Create your first deal to get started"}
            </p>
            {!searchQuery && (
              <Button
                onClick={onCreateDeal}
                className="bg-[#043b69] hover:bg-[#032d51]"
              >
                <Plus className="w-4 h-4 mr-2" />
                Create Deal
              </Button>
            )}
          </motion.div>
        ) : (
          <div className="space-y-4">
            {filteredDeals.map((deal, index) => (
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
        )}

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
