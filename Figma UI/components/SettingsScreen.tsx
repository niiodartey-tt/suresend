import { motion } from "motion/react";
import { ArrowLeft, ChevronRight, Globe, Bell, Lock, CreditCard, Moon, Sun } from "lucide-react";
import { Card } from "./ui/card";
import { Switch } from "./ui/switch";
import { useState } from "react";

interface SettingsScreenProps {
  onBack: () => void;
}

export function SettingsScreen({ onBack }: SettingsScreenProps) {
  const [darkMode, setDarkMode] = useState(false);
  const [notifications, setNotifications] = useState(true);
  const [emailAlerts, setEmailAlerts] = useState(true);

  const settingsSections = [
    {
      title: "Account",
      items: [
        { icon: Lock, label: "Security & Privacy", action: true },
        { icon: CreditCard, label: "Payment Methods", action: true },
        { icon: Bell, label: "Notification Preferences", action: true },
      ],
    },
    {
      title: "App Preferences",
      items: [
        { icon: Globe, label: "Language", value: "English", action: true },
      ],
    },
  ];

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
          <h2>Settings</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-6">
        {/* Quick Toggles */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <Card className="p-4 shadow-md">
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                {darkMode ? (
                  <Moon className="w-5 h-5 text-[#0A57E6]" />
                ) : (
                  <Sun className="w-5 h-5 text-[#0A57E6]" />
                )}
                <div>Dark Mode</div>
              </div>
              <Switch
                checked={darkMode}
                onCheckedChange={setDarkMode}
              />
            </div>
            <div className="flex items-center justify-between mb-4">
              <div className="flex items-center gap-3">
                <Bell className="w-5 h-5 text-[#0A57E6]" />
                <div>Push Notifications</div>
              </div>
              <Switch
                checked={notifications}
                onCheckedChange={setNotifications}
              />
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Bell className="w-5 h-5 text-[#0A57E6]" />
                <div>Email Alerts</div>
              </div>
              <Switch
                checked={emailAlerts}
                onCheckedChange={setEmailAlerts}
              />
            </div>
          </Card>
        </motion.div>

        {/* Settings Sections */}
        {settingsSections.map((section, sectionIndex) => (
          <motion.div
            key={section.title}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 + sectionIndex * 0.1 }}
          >
            <h4 className="mb-3">{section.title}</h4>
            <Card className="shadow-md overflow-hidden">
              {section.items.map((item, itemIndex) => {
                const Icon = item.icon;
                return (
                  <motion.div
                    key={item.label}
                    whileHover={{ backgroundColor: "#F9FAFB" }}
                    whileTap={{ scale: 0.98 }}
                    className="flex items-center justify-between p-4 cursor-pointer border-b last:border-b-0"
                  >
                    <div className="flex items-center gap-3">
                      <Icon className="w-5 h-5 text-gray-500" />
                      <div>{item.label}</div>
                    </div>
                    <div className="flex items-center gap-2">
                      {item.value && (
                        <span className="text-gray-500 text-sm">{item.value}</span>
                      )}
                      {item.action && <ChevronRight className="w-5 h-5 text-gray-400" />}
                    </div>
                  </motion.div>
                );
              })}
            </Card>
          </motion.div>
        ))}

        {/* App Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
        >
          <Card className="p-6 text-center shadow-md">
            <h3 className="mb-2">SecureEscrow</h3>
            <p className="text-gray-500 text-sm mb-1">Version 1.0.0</p>
            <p className="text-gray-400 text-xs">© 2025 All rights reserved</p>
          </Card>
        </motion.div>
      </div>
    </div>
  );
}
