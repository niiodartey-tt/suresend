import { motion } from "motion/react";
import { ArrowLeft, CheckCircle2, AlertCircle, Info, DollarSign } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";

interface NotificationDetailsProps {
  notification: any;
  onBack: () => void;
}

export function NotificationDetails({ notification, onBack }: NotificationDetailsProps) {
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

  const { icon: Icon, color, bg } = getNotificationIcon(notification?.type || "info");

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6"
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center gap-4">
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={onBack}
              className="p-2 hover:bg-white/10"
            >
              <ArrowLeft className="w-5 h-5" />
            </motion.button>
            <div>
              <h2>Notification Details</h2>
              <p className="text-xs opacity-80">{notification?.time || "Just now"}</p>
            </div>
          </div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
        >
          <Card className="p-6 shadow-lg">
            <div className="flex items-center gap-4 mb-6">
              <div className={`p-4 ${bg}`}>
                <Icon className={`w-8 h-8 ${color}`} />
              </div>
              <div className="flex-1">
                <h3 className="mb-1">{notification?.title || "Notification"}</h3>
                <p className="text-sm text-gray-500">{notification?.type || "General"}</p>
              </div>
            </div>

            <div className="mb-6">
              <p className="text-gray-700">{notification?.message || "No additional details available."}</p>
            </div>

            {notification?.details && (
              <div className="border-t pt-4 space-y-3">
                <h4 className="text-sm">Additional Information</h4>
                {Object.entries(notification.details).map(([key, value]: [string, any]) => (
                  <div key={key} className="flex justify-between text-sm">
                    <span className="text-gray-500 capitalize">{key.replace(/_/g, ' ')}</span>
                    <span>{value}</span>
                  </div>
                ))}
              </div>
            )}

            {notification?.actionUrl && (
              <div className="mt-6">
                <Button className="w-full bg-[#043b69] hover:bg-[#032d51]">
                  Take Action
                </Button>
              </div>
            )}
          </Card>

          <div className="mt-4">
            <Button
              onClick={onBack}
              variant="outline"
              className="w-full"
            >
              Close
            </Button>
          </div>
        </motion.div>
      </div>
    </div>
  );
}
