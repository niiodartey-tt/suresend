import { motion } from "motion/react";
import { ArrowLeft, ChevronRight, Globe, Bell, Lock, CreditCard, Moon, Sun, Shield, User, HelpCircle, FileText, LogOut, Smartphone } from "lucide-react";
import { Card } from "./ui/card";
import { Switch } from "./ui/switch";
import { Button } from "./ui/button";
import { 
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from "./ui/alert-dialog";
import { useState } from "react";
import { toast } from "sonner@2.0.3";
import { useTheme } from "./ThemeContext";
import { useNotificationService } from "./NotificationService";
import { useBiometric } from "./BiometricService";

interface SettingsScreenProps {
  onBack: () => void;
  onNavigate?: (screen: string) => void;
}

export function SettingsScreen({ onBack, onNavigate }: SettingsScreenProps) {
  const { isDark, toggleTheme } = useTheme();
  const { requestNotificationPermission, hasPermission } = useNotificationService();
  const { isAvailable: biometricAvailable, isEnrolled: biometricEnrolled, enroll } = useBiometric();
  
  const [notifications, setNotifications] = useState(hasPermission);
  const [emailAlerts, setEmailAlerts] = useState(true);
  const [twoFactorAuth, setTwoFactorAuth] = useState(false);
  const [biometric, setBiometric] = useState(biometricEnrolled);
  const [language, setLanguage] = useState("en");
  const [currency, setCurrency] = useState("USD");
  const [showLogoutDialog, setShowLogoutDialog] = useState(false);

  const handleNotificationsToggle = (checked: boolean) => {
    if (checked) {
      requestNotificationPermission();
    }
    setNotifications(checked);
    toast.success(checked ? "Push notifications enabled" : "Push notifications disabled");
  };

  const handleEmailAlertsToggle = (checked: boolean) => {
    setEmailAlerts(checked);
    toast.success(checked ? "Email alerts enabled" : "Email alerts disabled");
  };

  const handle2FAToggle = (checked: boolean) => {
    setTwoFactorAuth(checked);
    toast.success(checked ? "Two-factor authentication enabled" : "Two-factor authentication disabled");
  };

  const handleBiometricToggle = async (checked: boolean) => {
    if (checked && !biometricEnrolled) {
      const success = await enroll();
      if (success) {
        setBiometric(true);
        toast.success("Biometric authentication enabled");
      } else {
        setBiometric(false);
        toast.error("Failed to enable biometric authentication");
      }
    } else {
      setBiometric(checked);
      toast.success(checked ? "Biometric authentication enabled" : "Biometric authentication disabled");
    }
  };

  const handleLogout = () => {
    toast.success("Logged out successfully");
    setShowLogoutDialog(false);
    if (onNavigate) {
      onNavigate("login");
    }
  };

  const languageNames: { [key: string]: string } = {
    en: "English",
    es: "Spanish",
    fr: "French",
    de: "German",
  };

  return (
    <div className={`h-screen pb-24 overflow-y-auto ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'}`}>
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className={`p-6 text-white ${isDark ? 'bg-gradient-to-br from-gray-800 to-gray-900' : 'bg-gradient-to-br from-[#043b69] to-[#032d51]'}`}
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
            <h2>Settings</h2>
            <p className="text-xs opacity-80">Manage your preferences</p>
          </div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-6">
        {/* Appearance */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.1 }}
        >
          <h4 className={`mb-3 ${isDark ? 'text-white' : ''}`}>Appearance</h4>
          <Card className={`p-4 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                {isDark ? (
                  <Moon className="w-5 h-5 text-blue-500" />
                ) : (
                  <Sun className="w-5 h-5 text-[#043b69]" />
                )}
                <div>
                  <div className={isDark ? 'text-white' : ''}>Dark Mode</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                    {isDark ? 'Currently using dark theme' : 'Switch to dark theme'}
                  </p>
                </div>
              </div>
              <Switch
                checked={isDark}
                onCheckedChange={() => {
                  toggleTheme();
                  toast.success(isDark ? "Light mode enabled" : "Dark mode enabled");
                }}
              />
            </div>
          </Card>
        </motion.div>

        {/* Notifications */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
        >
          <h4 className={`mb-3 ${isDark ? 'text-white' : ''}`}>Notifications</h4>
          <Card className={`p-4 shadow-md space-y-4 ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Smartphone className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                <div>
                  <div className={isDark ? 'text-white' : ''}>Push Notifications</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                    Get real-time push notifications
                  </p>
                </div>
              </div>
              <Switch
                checked={notifications}
                onCheckedChange={handleNotificationsToggle}
              />
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Bell className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                <div>
                  <div className={isDark ? 'text-white' : ''}>Email Alerts</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Receive email updates</p>
                </div>
              </div>
              <Switch
                checked={emailAlerts}
                onCheckedChange={handleEmailAlertsToggle}
              />
            </div>
          </Card>
        </motion.div>

        {/* Security */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <h4 className={`mb-3 ${isDark ? 'text-white' : ''}`}>Security</h4>
          <Card className={`p-4 shadow-md space-y-4 ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Shield className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                <div>
                  <div className={isDark ? 'text-white' : ''}>Two-Factor Authentication</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Add extra security layer</p>
                </div>
              </div>
              <Switch
                checked={twoFactorAuth}
                onCheckedChange={handle2FAToggle}
              />
            </div>
            <div className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                <Lock className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                <div>
                  <div className={isDark ? 'text-white' : ''}>Biometric Login</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Use fingerprint/face ID</p>
                </div>
              </div>
              <Switch
                checked={biometric}
                onCheckedChange={handleBiometricToggle}
              />
            </div>
          </Card>
        </motion.div>

        {/* Preferences */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
        >
          <h4 className={`mb-3 ${isDark ? 'text-white' : ''}`}>Preferences</h4>
          <Card className={`p-4 shadow-md space-y-3 ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
            <motion.button
              whileTap={{ scale: 0.98 }}
              className={`w-full flex items-center justify-between p-3 rounded-lg ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`}
              onClick={() => toast.info("Language settings")}
            >
              <div className="flex items-center gap-3">
                <Globe className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-600'}`} />
                <div className="text-left">
                  <div className={`text-sm ${isDark ? 'text-white' : ''}`}>Language</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                    {languageNames[language]}
                  </p>
                </div>
              </div>
              <ChevronRight className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-400'}`} />
            </motion.button>

            <motion.button
              whileTap={{ scale: 0.98 }}
              className={`w-full flex items-center justify-between p-3 rounded-lg ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`}
              onClick={() => toast.info("Currency settings")}
            >
              <div className="flex items-center gap-3">
                <CreditCard className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-600'}`} />
                <div className="text-left">
                  <div className={`text-sm ${isDark ? 'text-white' : ''}`}>Currency</div>
                  <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>{currency}</p>
                </div>
              </div>
              <ChevronRight className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-400'}`} />
            </motion.button>
          </Card>
        </motion.div>

        {/* Help & Support */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
        >
          <h4 className={`mb-3 ${isDark ? 'text-white' : ''}`}>Help & Support</h4>
          <Card className={`p-4 shadow-md space-y-3 ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
            <motion.button
              whileTap={{ scale: 0.98 }}
              className={`w-full flex items-center justify-between p-3 rounded-lg ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`}
              onClick={() => toast.info("Help center")}
            >
              <div className="flex items-center gap-3">
                <HelpCircle className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-600'}`} />
                <span className={`text-sm ${isDark ? 'text-white' : ''}`}>Help Center</span>
              </div>
              <ChevronRight className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-400'}`} />
            </motion.button>

            <motion.button
              whileTap={{ scale: 0.98 }}
              className={`w-full flex items-center justify-between p-3 rounded-lg ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-50'}`}
              onClick={() => toast.info("Privacy policy")}
            >
              <div className="flex items-center gap-3">
                <FileText className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-600'}`} />
                <span className={`text-sm ${isDark ? 'text-white' : ''}`}>Privacy Policy</span>
              </div>
              <ChevronRight className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-400'}`} />
            </motion.button>
          </Card>
        </motion.div>

        {/* Logout */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.6 }}
        >
          <Button
            variant="outline"
            className={`w-full h-12 gap-2 ${isDark ? 'border-red-600 text-red-400 hover:bg-red-900/20' : 'text-red-600 hover:bg-red-50 border-red-200'}`}
            onClick={() => setShowLogoutDialog(true)}
          >
            <LogOut className="w-4 h-4" />
            Logout
          </Button>
        </motion.div>
      </div>

      {/* Logout Confirmation Dialog */}
      <AlertDialog open={showLogoutDialog} onOpenChange={setShowLogoutDialog}>
        <AlertDialogContent className={isDark ? 'bg-gray-800 border-gray-700' : ''}>
          <AlertDialogHeader>
            <AlertDialogTitle className={isDark ? 'text-white' : ''}>
              Logout
            </AlertDialogTitle>
            <AlertDialogDescription className={isDark ? 'text-gray-400' : ''}>
              Are you sure you want to logout? You'll need to sign in again to access your account.
            </AlertDialogDescription>
          </AlertDialogHeader>
          <AlertDialogFooter>
            <AlertDialogCancel className={isDark ? 'bg-gray-700 text-white border-gray-600' : ''}>
              Cancel
            </AlertDialogCancel>
            <AlertDialogAction
              onClick={handleLogout}
              className={`${isDark ? 'bg-red-600 hover:bg-red-700' : 'bg-red-600 hover:bg-red-700'} text-white`}
            >
              Logout
            </AlertDialogAction>
          </AlertDialogFooter>
        </AlertDialogContent>
      </AlertDialog>
    </div>
  );
}
