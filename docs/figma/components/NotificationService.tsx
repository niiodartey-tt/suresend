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
    
    // Automatic notification disabled - status updates no longer trigger notifications
    // You can manually add notifications using addNotification() if needed
  };

  // Automatic notifications disabled
  // You can manually trigger notifications using addNotification() or updateTransactionStatus()

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
