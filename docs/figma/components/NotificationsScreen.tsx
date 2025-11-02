import { motion } from "motion/react";
import { ArrowLeft, CheckCircle2, AlertCircle, Info, DollarSign, Search, X, Filter } from "lucide-react";
import { Card } from "./ui/card";
import { Input } from "./ui/input";
import { useState } from "react";
import { Button } from "./ui/button";
import { useTheme } from "./ThemeContext";
import { useNotificationService } from "./NotificationService";

interface NotificationsScreenProps {
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function NotificationsScreen({ onBack, onNavigate }: NotificationsScreenProps) {
  const { isDark } = useTheme();
  const { notifications: allNotifications, markAsRead } = useNotificationService();
  const [searchQuery, setSearchQuery] = useState("");
  const [filterType, setFilterType] = useState<string>("all");
  const [showFilters, setShowFilters] = useState(false);

  const oldNotifications = [
    {
      id: 1,
      type: "success",
      title: "New Escrow Created",
      message: "ESC-45823 - MacBook Pro M3 escrow created with Sarah Johnson",
      time: "2m ago",
      read: false,
      details: {
        transaction_id: "ESC-45823",
        amount: "$850.00",
        counterparty: "Sarah Johnson",
        role: "Buyer"
      }
    },
    {
      id: 2,
      type: "success",
      title: "Transaction Completed",
      message: "ESC-45822 - Web Development Service has been completed successfully",
      time: "1d ago",
      read: false,
      details: {
        transaction_id: "ESC-45822",
        amount: "$1,200.00",
        counterparty: "James Miller",
        role: "Seller"
      }
    },
    {
      id: 3,
      type: "alert",
      title: "Action Required",
      message: "Please confirm delivery for ESC-45821 - Gaming Console Bundle",
      time: "2d ago",
      read: false,
      details: {
        transaction_id: "ESC-45821",
        action: "Confirm Delivery",
        deadline: "Oct 30, 2025"
      }
    },
    {
      id: 4,
      type: "info",
      title: "New Message",
      message: "Mike Davis sent you a message about ESC-45821",
      time: "2d ago",
      read: true,
    },
    {
      id: 5,
      type: "payment",
      title: "Payment Received",
      message: "$2,500 added to your wallet",
      time: "3d ago",
      read: true,
      details: {
        amount: "$2,500.00",
        method: "Bank Transfer",
        reference: "TXN-789456"
      }
    },
    {
      id: 6,
      type: "alert",
      title: "Dispute Raised",
      message: "ESC-45819 - Camera Equipment has a dispute raised",
      time: "4d ago",
      read: true,
      details: {
        transaction_id: "ESC-45819",
        raised_by: "Robert Chen",
        reason: "Item not as described"
      }
    },
    {
      id: 7,
      type: "success",
      title: "Funds Released",
      message: "ESC-45818 - iPhone 15 Pro Max funds released to you",
      time: "5d ago",
      read: true,
      details: {
        transaction_id: "ESC-45818",
        amount: "$1,800.00",
        released_to: "Your Wallet"
      }
    },
    {
      id: 8,
      type: "info",
      title: "Shipping Confirmed",
      message: "Lisa Anderson confirmed shipment for ESC-45818",
      time: "6d ago",
      read: true,
    },
    {
      id: 9,
      type: "success",
      title: "KYC Verified",
      message: "Your account has been verified successfully",
      time: "7d ago",
      read: true,
      details: {
        verification_date: "Oct 22, 2025",
        verified_by: "Compliance Team"
      }
    },
    {
      id: 10,
      type: "payment",
      title: "Withdrawal Completed",
      message: "$500 has been sent to your bank account",
      time: "10d ago",
      read: true,
      details: {
        amount: "$500.00",
        bank: "Bank ending in 1234",
        reference: "WTH-123456"
      }
    }
  ];

  // Filter notifications
  const filteredNotifications = allNotifications.filter((notif) => {
    const matchesSearch = 
      notif.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      notif.message.toLowerCase().includes(searchQuery.toLowerCase());
    
    const matchesFilter = 
      filterType === "all" ||
      (filterType === "unread" && !notif.read) ||
      (filterType === notif.type);
    
    return matchesSearch && matchesFilter;
  });

  const filterOptions = [
    { value: "all", label: "All" },
    { value: "unread", label: "Unread" },
    { value: "success", label: "Success" },
    { value: "alert", label: "Alerts" },
    { value: "info", label: "Info" },
    { value: "payment", label: "Payments" },
  ];

  const getNotificationIcon = (type: string) => {
    switch (type) {
      case "success":
        return { icon: CheckCircle2, color: "text-green-600", bg: "bg-green-100" };
      case "alert":
        return { icon: AlertCircle, color: "text-red-600", bg: "bg-red-100" };
      case "info":
        return { icon: Info, color: "text-blue-600", bg: "bg-blue-100" };
      case "payment":
        return { icon: DollarSign, color: "text-purple-600", bg: "bg-purple-100" };
      default:
        return { icon: Info, color: "text-gray-600", bg: "bg-gray-100" };
    }
  };

  const getAccentColor = (type: string) => {
    switch (type) {
      case "success":
        return "border-l-green-600";
      case "alert":
        return "border-l-red-600";
      case "info":
        return "border-l-blue-600";
      case "payment":
        return "border-l-purple-600";
      default:
        return "border-l-gray-600";
    }
  };

  return (
    <div className={`h-screen pb-24 overflow-y-auto ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'}`}>
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`text-white p-6 ${isDark ? 'bg-gradient-to-br from-gray-800 to-gray-900' : 'bg-gradient-to-br from-[#043b69] to-[#032d51]'}`}
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
                <h2>Notifications</h2>
                <p className="text-xs opacity-80">{allNotifications.filter(n => !n.read).length} unread</p>
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
              placeholder="Search notifications..."
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
                    setFilterType(option.value);
                    setShowFilters(false);
                  }}
                  className={`px-3 py-1.5 text-sm transition-colors ${
                    filterType === option.value
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

      <div className="max-w-md mx-auto p-6 space-y-3">
        {filteredNotifications.length === 0 ? (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center py-12"
          >
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <Info className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="mb-2">No notifications found</h3>
            <p className="text-gray-500">
              {searchQuery 
                ? "Try adjusting your search or filters" 
                : "You're all caught up!"}
            </p>
          </motion.div>
        ) : (
          <>
            {filteredNotifications.map((notification, index) => {
          const { icon: Icon, color, bg } = getNotificationIcon(notification.type);
          const accentColor = getAccentColor(notification.type);

          return (
            <motion.div
              key={notification.id}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              whileHover={{ scale: 1.02 }}
              whileTap={{ scale: 0.98 }}
              onClick={() => {
                markAsRead(notification.id);
                onNavigate("notification-details", notification);
              }}
            >
              <Card className={`p-4 shadow-sm hover:shadow-md transition-all border-l-4 cursor-pointer ${accentColor} ${
                !notification.read ? (isDark ? "bg-blue-900/20 border-l-blue-500" : "bg-blue-50/30 border-l-[#043b69]") : (isDark ? "bg-gray-800 border-gray-700" : "")
              }`}>
                <div className="flex items-start gap-3">
                  <div className={`p-2 ${bg} shrink-0`}>
                    <Icon className={`w-5 h-5 ${color}`} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start mb-1">
                      <div className={!notification.read ? "" : "text-gray-700"}>
                        {notification.title}
                      </div>
                      {!notification.read && (
                        <motion.div
                          initial={{ scale: 0 }}
                          animate={{ scale: 1 }}
                          className="w-2 h-2 bg-[#043b69] rounded-full shrink-0 ml-2"
                        />
                      )}
                    </div>
                    <p className="text-gray-500 text-sm mb-2">
                      {notification.message}
                    </p>
                    <span className="text-xs text-gray-400">{notification.time}</span>
                  </div>
                </div>
              </Card>
            </motion.div>
          );
            })}
          </>
        )}
      </div>
    </div>
  );
}
