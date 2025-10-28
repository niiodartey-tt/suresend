import { motion } from "motion/react";
import { ArrowLeft, Edit2, Mail, Phone, MapPin, CheckCircle2, LogOut, Settings } from "lucide-react";
import { Button } from "./ui/button";
import { Card } from "./ui/card";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Badge } from "./ui/badge";

interface ProfileScreenProps {
  onBack: () => void;
  onNavigate: (screen: string) => void;
}

export function ProfileScreen({ onBack, onNavigate }: ProfileScreenProps) {
  const profileData = {
    name: "John Doe",
    email: "john.doe@example.com",
    phone: "+1 (234) 567-8900",
    location: "New York, USA",
    kycStatus: "Verified",
    memberSince: "Jan 2024",
  };

  const stats = [
    { label: "Total Deals", value: 59 },
    { label: "Success Rate", value: "98%" },
    { label: "Rating", value: "4.9" },
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
          <h2>Profile</h2>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        {/* Profile Header */}
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          transition={{ type: "spring", stiffness: 200 }}
        >
          <Card className="p-6 text-center shadow-md mb-6">
            <motion.div
              whileHover={{ scale: 1.1 }}
              whileTap={{ scale: 0.95 }}
              className="relative inline-block mb-4"
            >
              <Avatar className="w-24 h-24">
                <AvatarFallback className="bg-[#043b69] text-white text-2xl">
                  JD
                </AvatarFallback>
              </Avatar>
              <motion.button
                whileTap={{ scale: 0.9 }}
                className="absolute bottom-0 right-0 bg-white rounded-full p-2 shadow-lg"
              >
                <Edit2 className="w-4 h-4 text-[#043b69]" />
              </motion.button>
            </motion.div>
            <h2 className="mb-1">{profileData.name}</h2>
            <p className="text-gray-500 text-sm mb-3">
              Member since {profileData.memberSince}
            </p>
            <Badge className="bg-green-100 text-green-700 hover:bg-green-100">
              <CheckCircle2 className="w-3 h-3 mr-1" />
              {profileData.kycStatus}
            </Badge>
          </Card>
        </motion.div>

        {/* Stats */}
        <div className="grid grid-cols-3 gap-3 mb-6">
          {stats.map((stat, index) => (
            <motion.div
              key={stat.label}
              initial={{ opacity: 0, y: 20 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.1 + index * 0.1 }}
              whileHover={{ y: -4 }}
            >
              <Card className="p-4 text-center shadow-sm">
                <div className="text-xl mb-1">{stat.value}</div>
                <p className="text-xs text-gray-500">{stat.label}</p>
              </Card>
            </motion.div>
          ))}
        </div>

        {/* Contact Info */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.3 }}
        >
          <Card className="p-6 shadow-md mb-6">
            <h4 className="mb-4">Contact Information</h4>
            <div className="space-y-4">
              <div className="flex items-center gap-3">
                <div className="p-2 bg-blue-100 rounded-lg">
                  <Mail className="w-5 h-5 text-[#0A57E6]" />
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-500">Email</p>
                  <div>{profileData.email}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="p-2 bg-green-100 rounded-lg">
                  <Phone className="w-5 h-5 text-green-600" />
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-500">Phone</p>
                  <div>{profileData.phone}</div>
                </div>
              </div>
              <div className="flex items-center gap-3">
                <div className="p-2 bg-purple-100 rounded-lg">
                  <MapPin className="w-5 h-5 text-purple-600" />
                </div>
                <div className="flex-1">
                  <p className="text-sm text-gray-500">Location</p>
                  <div>{profileData.location}</div>
                </div>
              </div>
            </div>
          </Card>
        </motion.div>

        {/* Actions */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.4 }}
          className="space-y-3"
        >
          <motion.div whileTap={{ scale: 0.98 }}>
            <Button
              onClick={() => onNavigate("settings")}
              variant="outline"
              className="w-full justify-start gap-3 h-12"
            >
              <Settings className="w-5 h-5" />
              Settings
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.98 }}>
            <Button
              variant="outline"
              className="w-full justify-start gap-3 h-12"
            >
              <Edit2 className="w-5 h-5" />
              Edit Profile
            </Button>
          </motion.div>
          <motion.div whileTap={{ scale: 0.98 }}>
            <Button
              variant="outline"
              className="w-full justify-start gap-3 h-12 text-red-600 border-red-200 hover:bg-red-50"
            >
              <LogOut className="w-5 h-5" />
              Logout
            </Button>
          </motion.div>
        </motion.div>
      </div>
    </div>
  );
}
