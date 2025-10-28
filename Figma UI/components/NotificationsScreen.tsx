import { motion } from "motion/react";
import { ArrowLeft, CheckCircle2, AlertCircle, Info, DollarSign } from "lucide-react";
import { Card } from "./ui/card";

interface NotificationsScreenProps {
  onBack: () => void;
}

export function NotificationsScreen({ onBack }: NotificationsScreenProps) {
  const notifications = [
    {
      id: 1,
      type: "success",
      title: "Transaction Completed",
      message: "ESC-10233 has been completed successfully",
      time: "2m ago",
      read: false,
    },
    {
      id: 2,
      type: "alert",
      title: "Action Required",
      message: "Please release funds for ESC-10234",
      time: "1h ago",
      read: false,
    },
    {
      id: 3,
      type: "info",
      title: "New Message",
      message: "Alice Smith sent you a message",
      time: "3h ago",
      read: true,
    },
    {
      id: 4,
      type: "payment",
      title: "Payment Received",
      message: "$1,200 added to your wallet",
      time: "1d ago",
      read: true,
    },
    {
      id: 5,
      type: "success",
      title: "KYC Verified",
      message: "Your account has been verified",
      time: "2d ago",
      read: true,
    },
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
          <h2>Notifications</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-3">
        {notifications.map((notification, index) => {
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
            >
              <Card className={`p-4 shadow-sm hover:shadow-md transition-shadow border-l-4 ${accentColor} ${
                !notification.read ? "bg-blue-50/30" : ""
              }`}>
                <div className="flex items-start gap-3">
                  <div className={`p-2 rounded-lg ${bg} shrink-0`}>
                    <Icon className={`w-5 h-5 ${color}`} />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-start mb-1">
                      <div>{notification.title}</div>
                      {!notification.read && (
                        <motion.div
                          initial={{ scale: 0 }}
                          animate={{ scale: 1 }}
                          className="w-2 h-2 bg-[#0A57E6] rounded-full shrink-0"
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
      </div>
    </div>
  );
}
