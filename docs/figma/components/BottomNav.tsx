import { motion } from "motion/react";
import { LayoutDashboard, FileText, Plus, Settings, User } from "lucide-react";

interface BottomNavProps {
  activeScreen: string;
  onNavigate: (screen: string) => void;
  onCreateTransaction: () => void;
}

export function BottomNav({ activeScreen, onNavigate, onCreateTransaction }: BottomNavProps) {
  const navItems = [
    { id: "dashboard", icon: LayoutDashboard, label: "Dashboard" },
    { id: "deals", icon: FileText, label: "Deals" },
    { id: "create", icon: Plus, label: "Create" },
    { id: "settings", icon: Settings, label: "Settings" },
    { id: "profile", icon: User, label: "Profile" },
  ];

  return (
    <div className="fixed bottom-0 left-0 right-0 bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 safe-area-bottom z-40">
      <div className="max-w-md mx-auto flex items-center justify-around px-1 sm:px-2 py-2 sm:py-3">
        {navItems.map((item) => {
          const Icon = item.icon;
          const isActive = activeScreen === item.id;
          const isCreate = item.id === "create";

          if (isCreate) {
            return (
              <motion.button
                key={item.id}
                whileTap={{ scale: 0.9 }}
                whileHover={{ scale: 1.1 }}
                onClick={onCreateTransaction}
                className="relative -mt-6 sm:-mt-8"
              >
                <div className="bg-[#043b69] p-3 sm:p-4 shadow-lg rounded-full">
                  <Icon className="w-5 h-5 sm:w-6 sm:h-6 text-white" />
                </div>
              </motion.button>
            );
          }

          return (
            <motion.button
              key={item.id}
              whileTap={{ scale: 0.95 }}
              onClick={() => onNavigate(item.id)}
              className="flex flex-col items-center gap-0.5 sm:gap-1 px-2 sm:px-4 py-2 relative min-w-[60px] sm:min-w-[70px]"
            >
              <Icon
                className={`w-5 h-5 sm:w-6 sm:h-6 transition-colors ${
                  isActive ? "text-[#043b69] dark:text-blue-400" : "text-gray-400 dark:text-gray-500"
                }`}
              />
              <span className={`text-[10px] sm:text-xs transition-colors ${
                isActive ? "text-[#043b69] dark:text-blue-400" : "text-gray-400 dark:text-gray-500"
              }`}>
                {item.label}
              </span>
              {isActive && (
                <motion.div
                  layoutId="activeIndicator"
                  className="absolute -bottom-1 left-1/2 transform -translate-x-1/2 w-1 h-1 bg-[#043b69] dark:bg-blue-400"
                  transition={{ type: "spring", stiffness: 380, damping: 30 }}
                />
              )}
            </motion.button>
          );
        })}
      </div>
    </div>
  );
}
