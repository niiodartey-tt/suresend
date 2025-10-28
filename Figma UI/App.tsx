import { useState, useEffect } from "react";
import { motion, AnimatePresence } from "motion/react";
import { SplashScreen } from "./components/SplashScreen";
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
import { Toaster } from "./components/ui/sonner";

type Screen = 
  | "splash"
  | "dashboard"
  | "create-transaction"
  | "transaction-details"
  | "wallet"
  | "fund-wallet"
  | "withdraw"
  | "messages"
  | "chat"
  | "deals"
  | "profile"
  | "settings"
  | "notifications";

export default function App() {
  const [currentScreen, setCurrentScreen] = useState<Screen>("splash");
  const [showTransactionModal, setShowTransactionModal] = useState(false);
  const [transactionType, setTransactionType] = useState<"buy" | "sell" | null>(null);
  const [screenData, setScreenData] = useState<any>(null);
  const [screenHistory, setScreenHistory] = useState<Screen[]>([]);

  const handleNavigate = (screen: Screen, data?: any) => {
    setScreenHistory([...screenHistory, currentScreen]);
    setCurrentScreen(screen);
    setScreenData(data);
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
    handleNavigate("transaction-details", data);
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
        return <SplashScreen onComplete={() => setCurrentScreen("dashboard")} />;
      
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
        return <FundWallet onBack={handleBack} />;
      
      case "withdraw":
        return <WithdrawFunds onBack={handleBack} />;
      
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
        return <SettingsScreen onBack={handleBack} />;
      
      case "notifications":
        return <NotificationsScreen onBack={handleBack} />;
      
      default:
        return <Dashboard onNavigate={handleNavigate} />;
    }
  };

  const showBottomNav = !["splash", "chat", "create-transaction"].includes(currentScreen);

  return (
    <div className="size-full bg-[#F9FAFB] overflow-hidden">
      <div className="max-w-md mx-auto h-full relative bg-white shadow-2xl">
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

        <Toaster />
      </div>
    </div>
  );
}
