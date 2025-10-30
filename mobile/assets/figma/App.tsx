import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { SplashScreen } from "./components/SplashScreen";
import { OnboardingScreen } from "./components/OnboardingScreen";
import { LoginScreen } from "./components/LoginScreen";
import { SignUpScreen } from "./components/SignUpScreen";
import { ForgotPasswordScreen } from "./components/ForgotPasswordScreen";
import { Dashboard } from "./components/Dashboard";
import { BottomNav } from "./components/BottomNav";
import { TransactionTypeModal } from "./components/TransactionTypeModal";
import { CreateTransaction } from "./components/CreateTransaction";
import { TransactionDetails } from "./components/TransactionDetails";
import { WalletScreen } from "./components/WalletScreen";
import { FundWallet } from "./components/FundWallet";
import { WithdrawFunds } from "./components/WithdrawFunds";
import { MessagesList } from "./components/MessagesList";
import { ChatScreen } from "./components/ChatScreen";
import { DealsScreen } from "./components/DealsScreen";
import { ProfileScreen } from "./components/ProfileScreen";
import { SettingsScreen } from "./components/SettingsScreen";
import { NotificationsScreen } from "./components/NotificationsScreen";
import { NotificationDetails } from "./components/NotificationDetails";
import { TransactionHistory } from "./components/TransactionHistory";
import { PinConfirmation } from "./components/PinConfirmation";
import { TransactionSuccess } from "./components/TransactionSuccess";
import { Toaster } from "./components/ui/sonner";
import { ThemeProvider } from "./components/ThemeContext";
import { NotificationServiceProvider } from "./components/NotificationService";

type Screen = 
  | "splash"
  | "onboarding"
  | "login"
  | "signup"
  | "forgot-password"
  | "dashboard"
  | "create-transaction"
  | "transaction-details"
  | "transaction-history"
  | "wallet"
  | "fund-wallet"
  | "withdraw"
  | "messages"
  | "chat"
  | "deals"
  | "profile"
  | "settings"
  | "notifications"
  | "notification-details"
  | "pin-confirmation"
  | "transaction-success";

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>("splash");
  const [showTransactionModal, setShowTransactionModal] = useState(false);
  const [transactionType, setTransactionType] = useState<"buy" | "sell" | null>(null);
  const [screenData, setScreenData] = useState<any>(null);
  const [screenHistory, setScreenHistory] = useState<Screen[]>([]);
  const [showPinModal, setShowPinModal] = useState(false);
  const [pinAction, setPinAction] = useState<any>(null);
  const [globalState, setGlobalState] = useState<any>({
    notifications: [],
    messages: [],
    transactions: []
  });

  const handleNavigate = (screen: Screen, data?: any) => {
    // Handle PIN confirmation navigation
    if (screen === "pin-confirmation") {
      setShowPinModal(true);
      setPinAction(data);
      return;
    }
    
    setScreenHistory([...screenHistory, currentScreen]);
    setCurrentScreen(screen);
    setScreenData(data);
  };

  const handlePinConfirm = (pin: string) => {
    setShowPinModal(false);
    
    // Get transaction data and update status if releasing funds
    let transactionData = pinAction?.transaction || pinAction?.transactionData;
    
    if (pinAction?.action === "release") {
      // Update transaction status to Completed when releasing funds
      transactionData = {
        ...transactionData,
        status: "Completed"
      };
    }
    
    // If creating a new escrow, add notification to both buyer and seller
    if (pinAction?.action === "create-escrow") {
      // Simulate notification being sent to both parties
      const notification = {
        type: "success",
        title: "New Escrow Created",
        message: `Escrow transaction ${transactionData.id} has been created successfully`,
        time: "Just now"
      };
      
      // In a real app, this would be sent to both parties' accounts
      // For simulation purposes, we'll show a toast
      import("sonner@2.0.3").then(({ toast }) => {
        toast.success("Notifications sent to both parties");
      });
    }
    
    // Set success screen data with action type
    const successData = {
      transaction: transactionData,
      action: pinAction?.action
    };
    
    // Navigate to success screen after PIN confirmation
    setScreenHistory([...screenHistory, currentScreen]);
    setCurrentScreen("transaction-success");
    setScreenData(successData);
  };

  const handleBack = () => {
    if (screenHistory.length > 0) {
      const previousScreen = screenHistory[screenHistory.length - 1];
      setScreenHistory(screenHistory.slice(0, -1));
      setCurrentScreen(previousScreen);
      setScreenData(null);
    } else {
      setCurrentScreen("dashboard");
    }
  };

  const handleCreateTransaction = () => {
    setShowTransactionModal(true);
  };

  const handleSelectTransactionType = (type: "buy" | "sell") => {
    setTransactionType(type);
    setCurrentScreen("create-transaction");
  };

  const handleSubmitTransaction = (data: any) => {
    // If transaction requires PIN confirmation, show PIN modal first
    if (data.requiresPin) {
      // Create transaction data with ID
      const transactionData = {
        ...data,
        id: `ESC-${Math.floor(10000 + Math.random() * 90000)}`,
        status: "In Escrow",
        date: new Date().toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' }),
        role: data.transactionType === "buy" ? "buyer" : "seller",
        counterparty: data.counterpartyEmail,
        name: data.title,
        escrowFee: (parseFloat(data.amount) * 0.01).toFixed(2),
        category: data.category === "product" ? "Physical Product" : 
                 data.category === "service" ? "Service" :
                 data.category === "digital" ? "Digital Good" : "Other",
        expectedDelivery: new Date(Date.now() + 4 * 24 * 60 * 60 * 1000).toLocaleDateString('en-US', { month: 'short', day: 'numeric', year: 'numeric' })
      };
      
      setShowPinModal(true);
      setPinAction({ 
        action: "create-escrow", 
        transactionData: transactionData,
        transaction: transactionData
      });
    } else {
      handleNavigate("transaction-details", data);
    }
  };

  const pageTransition = {
    initial: { opacity: 0, x: 20 },
    animate: { opacity: 1, x: 0 },
    exit: { opacity: 0, x: -20 },
    transition: { duration: 0.3, ease: "easeInOut" }
  };

  const renderScreen = () => {
    switch (currentScreen) {
      case "splash":
        return <SplashScreen onComplete={() => setCurrentScreen("onboarding")} />;
      
      case "onboarding":
        return <OnboardingScreen onComplete={() => setCurrentScreen("login")} />;
      
      case "login":
        return (
          <LoginScreen
            onLogin={() => setCurrentScreen("dashboard")}
            onNavigate={handleNavigate}
          />
        );
      
      case "signup":
        return (
          <SignUpScreen
            onSignUp={() => setCurrentScreen("dashboard")}
            onBack={() => setCurrentScreen("login")}
          />
        );
      
      case "forgot-password":
        return (
          <ForgotPasswordScreen
            onBack={() => setCurrentScreen("login")}
            onNavigate={handleNavigate}
          />
        );
      
      case "dashboard":
        return <Dashboard onNavigate={handleNavigate} />;
      
      case "create-transaction":
        return (
          <CreateTransaction
            transactionType={transactionType || "sell"}
            onBack={handleBack}
            onSubmit={handleSubmitTransaction}
          />
        );
      
      case "transaction-details":
        return (
          <TransactionDetails
            transaction={screenData}
            onBack={handleBack}
            onNavigate={handleNavigate}
          />
        );
      
      case "wallet":
        return <WalletScreen onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "fund-wallet":
        return <FundWallet onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "withdraw":
        return <WithdrawFunds onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "messages":
        return (
          <MessagesList
            onBack={handleBack}
            onSelectChat={(chat) => handleNavigate("chat", chat)}
          />
        );
      
      case "chat":
        return <ChatScreen chat={screenData} onBack={handleBack} />;
      
      case "deals":
        return (
          <DealsScreen
            onBack={handleBack}
            onCreateDeal={handleCreateTransaction}
            onNavigate={handleNavigate}
          />
        );
      
      case "profile":
        return <ProfileScreen onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "settings":
        return <SettingsScreen onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "notifications":
        return <NotificationsScreen onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "notification-details":
        return <NotificationDetails notification={screenData} onBack={handleBack} />;
      
      case "transaction-history":
        return <TransactionHistory onBack={handleBack} onNavigate={handleNavigate} />;
      
      case "transaction-success":
        return (
          <TransactionSuccess
            transaction={screenData?.transaction || screenData}
            action={screenData?.action || pinAction?.action || "default"}
            onNavigate={handleNavigate}
          />
        );
      
      default:
        return <Dashboard onNavigate={handleNavigate} />;
    }
  };

  const showBottomNav = !["splash", "onboarding", "login", "signup", "forgot-password", "chat", "create-transaction", "transaction-success"].includes(currentScreen);

  return (
    <ThemeProvider>
      <NotificationServiceProvider>
        <div className="size-full bg-[#F9FAFB] dark:bg-gray-900 overflow-hidden">
          <div className="max-w-md mx-auto h-full relative bg-white dark:bg-gray-800 shadow-2xl">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentScreen}
            {...pageTransition}
            className="h-full"
          >
            {renderScreen()}
          </motion.div>
        </AnimatePresence>

        {showBottomNav && (
          <BottomNav
            activeScreen={currentScreen}
            onNavigate={(screen) => {
              if (screen === "dashboard") {
                setCurrentScreen("dashboard");
                setScreenHistory([]);
              } else if (screen === "deals") {
                handleNavigate("deals");
              } else if (screen === "settings") {
                handleNavigate("settings");
              } else if (screen === "profile") {
                handleNavigate("profile");
              }
            }}
            onCreateTransaction={handleCreateTransaction}
          />
        )}

        <TransactionTypeModal
          isOpen={showTransactionModal}
          onClose={() => setShowTransactionModal(false)}
          onSelect={handleSelectTransactionType}
        />

        <PinConfirmation
          isOpen={showPinModal}
          onClose={() => setShowPinModal(false)}
          onConfirm={handlePinConfirm}
          action={pinAction?.action || ""}
          transaction={pinAction?.transaction}
        />

        <Toaster />
          </div>
        </div>
      </NotificationServiceProvider>
    </ThemeProvider>
  );
}
