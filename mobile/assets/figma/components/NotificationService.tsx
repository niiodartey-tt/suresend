import { createContext, useContext, useState, useEffect, ReactNode } from "react";
import { toast } from "sonner@2.0.3";

interface Notification {
  id: number;
  type: "success" | "alert" | "info" | "payment";
  title: string;
  message: string;
  time: string;
  read: boolean;
  details?: any;
}

interface Transaction {
  id: string;
  name: string;
  status: string;
  amount: string;
  date: string;
  role: string;
  counterparty: string;
  category: string;
  description: string;
}

interface NotificationServiceContextType {
  notifications: Notification[];
  transactions: Transaction[];
  addNotification: (notification: Omit<Notification, "id" | "time" | "read">) => void;
  markAsRead: (id: number) => void;
  updateTransactionStatus: (id: string, newStatus: string) => void;
  requestNotificationPermission: () => void;
  hasPermission: boolean;
}

const NotificationServiceContext = createContext<NotificationServiceContextType>({
  notifications: [],
  transactions: [],
  addNotification: () => {},
  markAsRead: () => {},
  updateTransactionStatus: () => {},
  requestNotificationPermission: () => {},
  hasPermission: false,
});

export const useNotificationService = () => useContext(NotificationServiceContext);

export function NotificationServiceProvider({ children }: { children: ReactNode }) {
  const [notifications, setNotifications] = useState<Notification[]>([
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
  ]);

  const [transactions, setTransactions] = useState<Transaction[]>([
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
  ]);

  const [hasPermission, setHasPermission] = useState(false);

  // Request notification permission on mount
  useEffect(() => {
    if ("Notification" in window) {
      setHasPermission(Notification.permission === "granted");
    }
  }, []);

  const requestNotificationPermission = async () => {
    if ("Notification" in window && Notification.permission === "default") {
      const permission = await Notification.requestPermission();
      setHasPermission(permission === "granted");
      if (permission === "granted") {
        toast.success("Push notifications enabled!");
      }
    }
  };

  const showPushNotification = (title: string, message: string) => {
    if ("Notification" in window && Notification.permission === "granted") {
      new Notification(title, {
        body: message,
        icon: "/favicon.ico",
        badge: "/favicon.ico",
      });
    }
  };

  const addNotification = (notification: Omit<Notification, "id" | "time" | "read">) => {
    const newNotification: Notification = {
      ...notification,
      id: Date.now(),
      time: "Just now",
      read: false,
    };
    
    setNotifications(prev => [newNotification, ...prev]);
    toast.info(notification.title);
    showPushNotification(notification.title, notification.message);
  };

  const markAsRead = (id: number) => {
    setNotifications(prev =>
      prev.map(notif => notif.id === id ? { ...notif, read: true } : notif)
    );
  };

  const updateTransactionStatus = (id: string, newStatus: string) => {
    setTransactions(prev =>
      prev.map(tx => tx.id === id ? { ...tx, status: newStatus } : tx)
    );
    
    // Add notification about status change
    const transaction = transactions.find(tx => tx.id === id);
    if (transaction) {
      addNotification({
        type: newStatus === "Completed" ? "success" : "info",
        title: "Transaction Status Updated",
        message: `${id} status changed to ${newStatus}`,
        details: {
          transaction_id: id,
          new_status: newStatus,
        }
      });
    }
  };

  // Simulate real-time transaction status progression
  useEffect(() => {
    const interval = setInterval(() => {
      setTransactions(prev => {
        const updated = [...prev];
        let hasChanges = false;

        updated.forEach((tx, index) => {
          // Random chance to progress transaction status
          const random = Math.random();
          
          if (tx.status === "In Escrow" && random < 0.1) {
            updated[index] = { ...tx, status: "In Progress" };
            hasChanges = true;
            
            addNotification({
              type: "info",
              title: "Transaction Updated",
              message: `${tx.id} - ${tx.name} is now in progress`,
              details: {
                transaction_id: tx.id,
                new_status: "In Progress"
              }
            });
          } else if (tx.status === "In Progress" && random < 0.08) {
            updated[index] = { ...tx, status: "Completed" };
            hasChanges = true;
            
            addNotification({
              type: "success",
              title: "Transaction Completed",
              message: `${tx.id} - ${tx.name} has been completed successfully`,
              details: {
                transaction_id: tx.id,
                amount: `$${tx.amount}`,
                counterparty: tx.counterparty
              }
            });
          }
        });

        return hasChanges ? updated : prev;
      });
    }, 30000); // Check every 30 seconds

    return () => clearInterval(interval);
  }, [transactions]);

  // Simulate random new notifications
  useEffect(() => {
    const interval = setInterval(() => {
      const random = Math.random();
      
      if (random < 0.15) { // 15% chance every minute
        const notificationTypes = [
          {
            type: "info" as const,
            title: "New Message",
            message: "You have a new message from a transaction partner",
          },
          {
            type: "payment" as const,
            title: "Payment Received",
            message: `$${(Math.random() * 1000 + 100).toFixed(2)} added to your wallet`,
          },
          {
            type: "alert" as const,
            title: "Action Required",
            message: "Please review and confirm a pending transaction",
          },
        ];
        
        const randomNotif = notificationTypes[Math.floor(Math.random() * notificationTypes.length)];
        addNotification(randomNotif);
      }
    }, 60000); // Check every minute

    return () => clearInterval(interval);
  }, []);

  return (
    <NotificationServiceContext.Provider
      value={{
        notifications,
        transactions,
        addNotification,
        markAsRead,
        updateTransactionStatus,
        requestNotificationPermission,
        hasPermission,
      }}
    >
      {children}
    </NotificationServiceContext.Provider>
  );
}
