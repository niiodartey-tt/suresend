import { motion } from "motion/react";
import { ArrowLeft, Save, Camera, User, Mail, Phone, MapPin } from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Textarea } from "./ui/textarea";
import { Card } from "./ui/card";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { useState } from "react";
import { toast } from "sonner@2.0.3";
import { useTheme } from "./ThemeContext";

interface EditProfileScreenProps {
  onBack: () => void;
  onSave?: (data: any) => void;
}

export function EditProfileScreen({ onBack, onSave }: EditProfileScreenProps) {
  const { isDark } = useTheme();
  
  // Initialize with existing profile data
  const [formData, setFormData] = useState({
    name: "John Doe",
    username: "@johndoe",
    email: "john.doe@example.com",
    phone: "+1 (234) 567-8900",
    location: "New York, USA",
    bio: "Professional buyer and seller on the platform. Specializing in electronics and tech products.",
  });

  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);
    
    // Simulate API call
    setTimeout(() => {
      setIsLoading(false);
      toast.success("Profile updated successfully!");
      if (onSave) {
        onSave(formData);
      }
      onBack();
    }, 1000);
  };

  const handleChange = (field: string, value: string) => {
    setFormData({ ...formData, [field]: value });
  };

  return (
    <div className={`h-screen pb-24 overflow-y-auto ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'}`}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`sticky top-0 z-10 ${isDark ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-b p-4`}
      >
        <div className="flex items-center justify-between max-w-md mx-auto">
          <div className="flex items-center gap-4">
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={onBack}
              className={`p-2 rounded-full ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
            >
              <ArrowLeft className="w-5 h-5" />
            </motion.button>
            <h2 className={isDark ? 'text-white' : ''}>Edit Profile</h2>
          </div>
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={handleSubmit}
            disabled={isLoading}
            className={`flex items-center gap-2 px-4 py-2 rounded-full ${
              isDark 
                ? 'bg-blue-600 hover:bg-blue-700 text-white' 
                : 'bg-[#043b69] hover:bg-[#032d51] text-white'
            } ${isLoading ? 'opacity-50 cursor-not-allowed' : ''}`}
          >
            <Save className="w-4 h-4" />
            Save
          </motion.button>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6">
        <form onSubmit={handleSubmit} className="space-y-6">
          {/* Profile Picture */}
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1 }}
          >
            <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
              <div className="flex flex-col items-center">
                <motion.div
                  whileHover={{ scale: 1.05 }}
                  className="relative cursor-pointer"
                >
                  <Avatar className="w-24 h-24">
                    <AvatarFallback className="bg-[#043b69] dark:bg-blue-600 text-white text-3xl">
                      JD
                    </AvatarFallback>
                  </Avatar>
                  <motion.div
                    whileHover={{ scale: 1.1 }}
                    whileTap={{ scale: 0.95 }}
                    className={`absolute bottom-0 right-0 p-2 rounded-full ${
                      isDark ? 'bg-blue-600' : 'bg-[#043b69]'
                    } text-white shadow-lg cursor-pointer`}
                  >
                    <Camera className="w-4 h-4" />
                  </motion.div>
                </motion.div>
                <p className={`text-sm mt-3 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                  Click to change profile picture
                </p>
              </div>
            </Card>
          </motion.div>

          {/* Personal Information */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.2 }}
          >
            <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
              <h4 className={`mb-4 flex items-center gap-2 ${isDark ? 'text-white' : ''}`}>
                <User className="w-4 h-4" />
                Personal Information
              </h4>
              
              <div className="space-y-4">
                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Full Name</Label>
                  <Input
                    value={formData.name}
                    onChange={(e) => handleChange('name', e.target.value)}
                    className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                    placeholder="Enter your full name"
                  />
                </div>

                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Username</Label>
                  <Input
                    value={formData.username}
                    onChange={(e) => handleChange('username', e.target.value)}
                    className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                    placeholder="@username"
                  />
                  <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                    Your unique username on the platform
                  </p>
                </div>

                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Bio</Label>
                  <Textarea
                    value={formData.bio}
                    onChange={(e) => handleChange('bio', e.target.value)}
                    className={`mt-2 min-h-[100px] ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                    placeholder="Tell us about yourself"
                  />
                </div>
              </div>
            </Card>
          </motion.div>

          {/* Contact Information */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.3 }}
          >
            <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
              <h4 className={`mb-4 flex items-center gap-2 ${isDark ? 'text-white' : ''}`}>
                <Mail className="w-4 h-4" />
                Contact Information
              </h4>
              
              <div className="space-y-4">
                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Email Address</Label>
                  <Input
                    type="email"
                    value={formData.email}
                    onChange={(e) => handleChange('email', e.target.value)}
                    className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                    placeholder="your.email@example.com"
                  />
                </div>

                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Phone Number</Label>
                  <Input
                    type="tel"
                    value={formData.phone}
                    onChange={(e) => handleChange('phone', e.target.value)}
                    className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                    placeholder="+1 (234) 567-8900"
                  />
                </div>

                <div>
                  <Label className={isDark ? 'text-gray-300' : ''}>Location</Label>
                  <div className="relative mt-2">
                    <MapPin className={`absolute left-3 top-1/2 transform -translate-y-1/2 w-4 h-4 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                    <Input
                      value={formData.location}
                      onChange={(e) => handleChange('location', e.target.value)}
                      className={`pl-10 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="City, Country"
                    />
                  </div>
                </div>
              </div>
            </Card>
          </motion.div>

          {/* Submit Button */}
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: 0.4 }}
          >
            <Button
              type="submit"
              disabled={isLoading}
              className={`w-full h-12 ${
                isDark 
                  ? 'bg-blue-600 hover:bg-blue-700' 
                  : 'bg-[#043b69] hover:bg-[#032d51]'
              } ${isLoading ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
              {isLoading ? (
                <div className="flex items-center gap-2">
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-5 h-5 border-2 border-white border-t-transparent rounded-full"
                  />
                  Saving...
                </div>
              ) : (
                <>
                  <Save className="w-4 h-4 mr-2" />
                  Save Changes
                </>
              )}
            </Button>
          </motion.div>
        </form>
      </div>
    </div>
  );
}
