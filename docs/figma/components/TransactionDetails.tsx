import { motion } from "motion/react";
import { 
  ArrowLeft, 
  MessageCircle, 
  AlertTriangle, 
  CheckCircle, 
  Clock, 
  User, 
  Package, 
  Calendar,
  DollarSign,
  MapPin,
  FileText,
  Download,
  CreditCard,
  Shield,
  Info
} from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Badge } from "./ui/badge";
import { Progress } from "./ui/progress";
import { Separator } from "./ui/separator";
import { toast } from "sonner@2.0.3";
import { useTheme } from "./ThemeContext";

interface TransactionDetailsProps {
  transaction: any;
  onBack: () => void;
  onNavigate: (screen: string, data?: any) => void;
}

export function TransactionDetails({ transaction, onBack, onNavigate }: TransactionDetailsProps) {
  const { isDark } = useTheme();
  // Determine transaction progress based on status
  const getStepsFromStatus = (status: string) => {
    const statusSteps: { [key: string]: number } = {
      "Pending": 0,
      "Initiated": 1,
      "In Escrow": 2,
      "In Progress": 2,
      "Delivered": 3,
      "Completed": 4,
      "Disputed": 2,
    };
    return statusSteps[status] || 1;
  };

  const currentStep = getStepsFromStatus(transaction?.status || "In Escrow");
  
  const steps = [
    { 
      label: "Initiated", 
      completed: currentStep >= 1, 
      date: currentStep >= 1 ? "Oct 24, 2025 10:30 AM" : null 
    },
    { 
      label: "In Escrow", 
      completed: currentStep >= 2, 
      date: currentStep >= 2 ? "Oct 24, 2025 10:35 AM" : null 
    },
    { 
      label: "Delivered", 
      completed: currentStep >= 3, 
      date: currentStep >= 3 ? "Oct 26, 2025 02:15 PM" : null 
    },
    { 
      label: "Completed", 
      completed: currentStep >= 4, 
      date: currentStep >= 4 ? new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }) + " " + new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' }) : null 
    },
  ];

  const progressValue = (steps.filter(s => s.completed).length / steps.length) * 100;

  // Handle null transaction
  if (!transaction) {
    transaction = {
      id: "ESC-10234",
      name: "iPhone 15 Pro",
      title: "iPhone 15 Pro",
      status: "In Escrow",
      amount: "450.00",
      date: "Oct 24, 2025",
      role: "buyer",
      counterparty: "Alice Smith",
      description: "Brand new iPhone 15 Pro, 256GB, Blue Titanium. Factory sealed with original accessories.",
      category: "Physical Product",
      escrowFee: "4.50",
      expectedDelivery: "Oct 28, 2025",
      paymentMethod: "Card ending in 4242",
      shippingAddress: "123 Main St, New York, NY 10001",
      terms: "Item must be as described. Buyer has 3 days to inspect and confirm receipt."
    };
  }

  const statusColor = isDark ? {
    "In Escrow": "bg-blue-900/30 text-blue-300",
    "Completed": "bg-green-900/30 text-green-300",
    "In Progress": "bg-orange-900/30 text-orange-300",
    "Pending": "bg-yellow-900/30 text-yellow-300",
    "Disputed": "bg-red-900/30 text-red-300"
  }[transaction.status] || "bg-gray-700 text-gray-300" : {
    "In Escrow": "bg-blue-100 text-blue-700",
    "Completed": "bg-green-100 text-green-700",
    "In Progress": "bg-orange-100 text-orange-700",
    "Pending": "bg-yellow-100 text-yellow-700",
    "Disputed": "bg-red-100 text-red-700"
  }[transaction.status] || "bg-gray-100 text-gray-700";

  const handleDownloadReceipt = () => {
    toast.success("Receipt downloaded successfully");
  };

  const handleRaiseDispute = () => {
    onNavigate("dispute", transaction);
  };

  const handleReleaseFunds = () => {
    onNavigate("pin-confirmation", { action: "release", transaction });
  };

  // Generate activity log based on transaction status
  const getActivityLog = (status: string, role: string, counterparty: string) => {
    const baseLog = [
      { action: "Transaction created", date: "Oct 24, 2025 10:30 AM", user: "You" },
      { action: "Funds deposited to escrow", date: "Oct 24, 2025 10:35 AM", user: "System" },
      { action: `${role === "buyer" ? "Seller" : "Buyer"} notified`, date: "Oct 24, 2025 10:36 AM", user: "System" },
    ];

    if (status === "Completed") {
      return [
        ...baseLog,
        { action: `${role === "buyer" ? "Seller" : "Buyer"} confirmed shipment`, date: "Oct 25, 2025 09:15 AM", user: counterparty },
        { action: "Item marked as delivered", date: "Oct 26, 2025 02:15 PM", user: "System" },
        { action: "Transaction completed", date: new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }) + " " + new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' }), user: "You" },
        { action: "Funds released to seller", date: new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }) + " " + new Date().toLocaleTimeString('en-US', { hour: 'numeric', minute: '2-digit' }), user: "System" },
      ];
    } else if (status === "Delivered" || status === "In Progress") {
      return [
        ...baseLog,
        { action: `${role === "buyer" ? "Seller" : "Buyer"} confirmed shipment`, date: "Oct 25, 2025 09:15 AM", user: counterparty },
        { action: "Item marked as delivered", date: "Oct 26, 2025 02:15 PM", user: "System" },
      ];
    } else if (status === "Disputed") {
      return [
        ...baseLog,
        { action: "Dispute raised", date: "Oct 25, 2025 03:45 PM", user: "You" },
        { action: "Dispute under review", date: "Oct 25, 2025 04:00 PM", user: "System" },
      ];
    } else {
      return baseLog;
    }
  };

  const activityLog = getActivityLog(
    transaction.status || "In Escrow", 
    transaction.role || "buyer",
    transaction.counterparty || "Alice Smith"
  );

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-gradient-to-br from-[#043b69] to-[#032d51] text-white p-6"
      >
        <div className="flex items-center gap-4 max-w-md mx-auto">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={onBack}
            className="p-2 hover:bg-white/10"
          >
            <ArrowLeft className="w-5 h-5" />
          </motion.button>
          <div>
            <h2>Transaction Details</h2>
            <p className="text-xs opacity-80">{transaction.id}</p>
          </div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-4">
        {/* Main Transaction Card */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card className="p-6 shadow-md">
            <div className="flex justify-between items-start mb-4">
              <div className="flex-1">
                <div className="flex items-start justify-between mb-2">
                  <h3 className="flex-1">{transaction.name || transaction.title}</h3>
                  <Badge className={`${statusColor} hover:${statusColor} ml-2`}>
                    {transaction.status}
                  </Badge>
                </div>
                <p className="text-gray-500 text-sm mb-4">{transaction.description}</p>
              </div>
            </div>
            
            <Separator className="my-4" />
            
            <div className="grid grid-cols-2 gap-4">
              <div>
                <p className="text-gray-500 text-xs mb-1">Amount</p>
                <div className="text-2xl">${transaction.amount}</div>
              </div>
              <div>
                <p className="text-gray-500 text-xs mb-1">Created</p>
                <div className="text-sm">{transaction.date}</div>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Progress Timeline */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <Card className="p-6 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <h4>Transaction Progress</h4>
              <span className="text-xs text-gray-500">{Math.round(progressValue)}%</span>
            </div>
            <Progress value={progressValue} className="mb-6" />
            <div className="space-y-4">
              {steps.map((step, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.3 + index * 0.1 }}
                  className="flex items-start gap-3"
                >
                  <div className="mt-0.5">
                    {step.completed ? (
                      <div className="w-6 h-6 bg-green-100 flex items-center justify-center">
                        <CheckCircle className="w-4 h-4 text-green-600" />
                      </div>
                    ) : (
                      <div className="w-6 h-6 border-2 border-gray-300 bg-white flex items-center justify-center">
                        <div className="w-2 h-2 bg-gray-300" />
                      </div>
                    )}
                  </div>
                  <div className="flex-1">
                    <div className={`${step.completed ? "text-gray-900" : "text-gray-400"}`}>
                      {step.label}
                    </div>
                    {step.date && (
                      <p className="text-xs text-gray-500 mt-1">{step.date}</p>
                    )}
                  </div>
                </motion.div>
              ))}
            </div>
          </Card>
        </motion.div>

        {/* Participants */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Participants</h4>
            <div className="space-y-4">
              <motion.div 
                whileHover={{ x: 4 }}
                className="flex items-center justify-between p-3 bg-gray-50 hover:bg-gray-100 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <Avatar className="w-12 h-12">
                    <AvatarFallback className="bg-[#043b69] text-white">JD</AvatarFallback>
                  </Avatar>
                  <div>
                    <div>John Doe</div>
                    <p className="text-xs text-gray-500">{transaction.role === "buyer" ? "Buyer" : "Seller"}</p>
                  </div>
                </div>
                <Badge variant="outline" className="text-xs">You</Badge>
              </motion.div>
              
              <motion.div 
                whileHover={{ x: 4 }}
                className="flex items-center justify-between p-3 bg-gray-50 hover:bg-gray-100 transition-colors"
              >
                <div className="flex items-center gap-3">
                  <Avatar className="w-12 h-12">
                    <AvatarFallback className="bg-green-100 text-green-700">AS</AvatarFallback>
                  </Avatar>
                  <div>
                    <div>{transaction.counterparty || "Alice Smith"}</div>
                    <p className="text-xs text-gray-500">{transaction.role === "buyer" ? "Seller" : "Buyer"}</p>
                  </div>
                </div>
                <motion.button
                  whileTap={{ scale: 0.95 }}
                  onClick={() => onNavigate("chat", transaction)}
                  className="text-xs text-[#043b69] hover:underline"
                >
                  Message
                </motion.button>
              </motion.div>
            </div>
          </Card>
        </motion.div>

        {/* Payment & Fees */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Payment Details</h4>
            <div className="space-y-3">
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3 text-sm">
                  <DollarSign className="w-4 h-4 text-gray-400" />
                  <span className="text-gray-500">Transaction Amount</span>
                </div>
                <span>${transaction.amount}</span>
              </div>
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3 text-sm">
                  <Shield className="w-4 h-4 text-gray-400" />
                  <span className="text-gray-500">Escrow Fee (1%)</span>
                </div>
                <span>${transaction.escrowFee || "4.50"}</span>
              </div>
              <Separator />
              <div className="flex items-center justify-between">
                <div className="flex items-center gap-3">
                  <span>Total Amount</span>
                </div>
                <span className="text-lg">${(parseFloat(transaction.amount) + parseFloat(transaction.escrowFee || "4.50")).toFixed(2)}</span>
              </div>
              <Separator />
              <div className="flex items-center gap-3 text-sm">
                <CreditCard className="w-4 h-4 text-gray-400" />
                <span className="text-gray-500">Payment Method:</span>
                <span>{transaction.paymentMethod || "Card ending in 4242"}</span>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Delivery & Additional Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Additional Details</h4>
            <div className="space-y-3">
              <div className="flex items-start gap-3 text-sm">
                <Package className="w-4 h-4 text-gray-400 mt-0.5" />
                <div className="flex-1">
                  <span className="text-gray-500">Category:</span>
                  <span className="ml-2">{transaction.category || "Physical Product"}</span>
                </div>
              </div>
              <div className="flex items-start gap-3 text-sm">
                <Calendar className="w-4 h-4 text-gray-400 mt-0.5" />
                <div className="flex-1">
                  <span className="text-gray-500">Expected Delivery:</span>
                  <span className="ml-2">{transaction.expectedDelivery || "Oct 28, 2025"}</span>
                </div>
              </div>
              {transaction.shippingAddress && (
                <div className="flex items-start gap-3 text-sm">
                  <MapPin className="w-4 h-4 text-gray-400 mt-0.5" />
                  <div className="flex-1">
                    <span className="text-gray-500">Shipping Address:</span>
                    <p className="mt-1">{transaction.shippingAddress}</p>
                  </div>
                </div>
              )}
            </div>
          </Card>
        </motion.div>

        {/* Terms & Conditions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
        >
          <Card className="p-6 shadow-md">
            <div className="flex items-center gap-2 mb-3">
              <FileText className="w-4 h-4 text-gray-400" />
              <h4>Terms & Conditions</h4>
            </div>
            <p className="text-sm text-gray-600">
              {transaction.terms || "Item must be as described. Buyer has 3 days to inspect and confirm receipt. Seller must ship within 2 business days of escrow confirmation."}
            </p>
          </Card>
        </motion.div>

        {/* Activity Log */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.7 }}
        >
          <Card className="p-6 shadow-md">
            <h4 className="mb-4">Activity Log</h4>
            <div className="space-y-3">
              {activityLog.map((activity, index) => (
                <motion.div
                  key={index}
                  initial={{ opacity: 0, x: -20 }}
                  animate={{ opacity: 1, x: 0 }}
                  transition={{ delay: 0.8 + index * 0.05 }}
                  className="flex gap-3 border-l-2 border-gray-200 pl-4 py-2"
                >
                  <div className="flex-1">
                    <div className="text-sm">{activity.action}</div>
                    <div className="text-xs text-gray-500 mt-1">
                      {activity.date} • {activity.user}
                    </div>
                  </div>
                </motion.div>
              ))}
            </div>
          </Card>
        </motion.div>

        {/* Download Receipt */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.8 }}
        >
          <Button
            variant="outline"
            className="w-full h-12 gap-2"
            onClick={handleDownloadReceipt}
          >
            <Download className="w-4 h-4" />
            Download Receipt
          </Button>
        </motion.div>

        {/* Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.9 }}
          className="space-y-3"
        >
          {transaction.status === "In Escrow" && transaction.role === "buyer" && (
            <Button
              className="w-full bg-[#043b69] hover:bg-[#032d51] shadow-lg h-12"
              onClick={handleReleaseFunds}
            >
              <CheckCircle className="w-4 h-4 mr-2" />
              Confirm & Release Funds
            </Button>
          )}
          
          {transaction.status !== "Completed" && transaction.status !== "Disputed" && (
            <Button
              variant="outline"
              className="w-full border-2 border-red-600 text-red-600 hover:bg-red-50 h-12"
              onClick={handleRaiseDispute}
            >
              <AlertTriangle className="w-4 h-4 mr-2" />
              Raise Dispute
            </Button>
          )}
          
          {transaction.status === "Completed" && (
            <div className="bg-green-50 border border-green-200 p-4 flex items-center gap-3">
              <CheckCircle className="w-5 h-5 text-green-600" />
              <div>
                <div className="text-sm text-green-800">Transaction Completed</div>
                <p className="text-xs text-green-600 mt-1">Funds have been released successfully</p>
              </div>
            </div>
          )}
        </motion.div>

        {/* Info Banner */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1.0 }}
        >
          <div className="bg-blue-50 border border-blue-200 p-4 flex items-start gap-3">
            <Info className="w-5 h-5 text-blue-600 mt-0.5" />
            <div className="flex-1">
              <div className="text-sm text-blue-800">Secure Escrow Protection</div>
              <p className="text-xs text-blue-600 mt-1">
                Your funds are held securely in escrow until both parties confirm the transaction is complete.
              </p>
            </div>
          </div>
        </motion.div>

        {/* Chat Button */}
        <motion.button
          whileHover={{ scale: 1.05 }}
          whileTap={{ scale: 0.95 }}
          onClick={() => onNavigate("chat", transaction)}
          className="fixed bottom-24 right-6 bg-[#043b69] text-white p-4 rounded-full shadow-lg z-20"
        >
          <MessageCircle className="w-6 h-6" />
        </motion.button>
      </div>
    </div>
  );
}
