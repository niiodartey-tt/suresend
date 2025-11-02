import { motion, AnimatePresence } from "motion/react";
import { 
  ArrowLeft, 
  ArrowRight, 
  CheckCircle, 
  Upload, 
  User, 
  FileText, 
  Camera,
  AlertCircle,
  Shield,
  MapPin,
  Calendar,
  CreditCard,
  Home as HomeIcon
} from "lucide-react";
import { Button } from "./ui/button";
import { Input } from "./ui/input";
import { Label } from "./ui/label";
import { Card } from "./ui/card";
import { useState } from "react";
import { toast } from "sonner@2.0.3";
import { useTheme } from "./ThemeContext";
import { 
  Select, 
  SelectContent, 
  SelectItem, 
  SelectTrigger, 
  SelectValue 
} from "./ui/select";
import { Progress } from "./ui/progress";

interface KYCVerificationScreenProps {
  onBack: () => void;
  onComplete: (kycData: any) => void;
}

interface KYCData {
  // Personal Information
  firstName: string;
  lastName: string;
  dateOfBirth: string;
  phoneNumber: string;
  email: string;
  
  // Address Information
  streetAddress: string;
  city: string;
  state: string;
  zipCode: string;
  country: string;
  
  // Identity Verification
  idType: string;
  idNumber: string;
  idExpiry: string;
  
  // Documents
  idFrontPhoto: File | null;
  idBackPhoto: File | null;
  selfiePhoto: File | null;
  addressProof: File | null;
}

export function KYCVerificationScreen({ onBack, onComplete }: KYCVerificationScreenProps) {
  const { isDark } = useTheme();
  const [currentStep, setCurrentStep] = useState(1);
  const [isSubmitting, setIsSubmitting] = useState(false);
  
  const [kycData, setKycData] = useState<KYCData>({
    firstName: "",
    lastName: "",
    dateOfBirth: "",
    phoneNumber: "",
    email: "",
    streetAddress: "",
    city: "",
    state: "",
    zipCode: "",
    country: "United States",
    idType: "",
    idNumber: "",
    idExpiry: "",
    idFrontPhoto: null,
    idBackPhoto: null,
    selfiePhoto: null,
    addressProof: null,
  });

  const totalSteps = 4;
  const progress = (currentStep / totalSteps) * 100;

  const updateField = (field: keyof KYCData, value: any) => {
    setKycData(prev => ({ ...prev, [field]: value }));
  };

  const validateStep = (step: number): boolean => {
    switch (step) {
      case 1: // Personal Information
        if (!kycData.firstName || !kycData.lastName || !kycData.dateOfBirth || !kycData.phoneNumber) {
          toast.error("Please fill in all required personal information");
          return false;
        }
        // Validate age (must be 18+)
        const age = new Date().getFullYear() - new Date(kycData.dateOfBirth).getFullYear();
        if (age < 18) {
          toast.error("You must be at least 18 years old");
          return false;
        }
        return true;
      
      case 2: // Address Information
        if (!kycData.streetAddress || !kycData.city || !kycData.state || !kycData.zipCode) {
          toast.error("Please fill in all required address information");
          return false;
        }
        return true;
      
      case 3: // Identity Verification
        if (!kycData.idType || !kycData.idNumber || !kycData.idExpiry) {
          toast.error("Please fill in all required identity information");
          return false;
        }
        return true;
      
      case 4: // Document Upload
        if (!kycData.idFrontPhoto || !kycData.selfiePhoto) {
          toast.error("Please upload required documents (ID front and selfie)");
          return false;
        }
        return true;
      
      default:
        return true;
    }
  };

  const handleNext = () => {
    if (validateStep(currentStep)) {
      if (currentStep < totalSteps) {
        setCurrentStep(currentStep + 1);
      }
    }
  };

  const handleBack = () => {
    if (currentStep > 1) {
      setCurrentStep(currentStep - 1);
    } else {
      onBack();
    }
  };

  const handleFileUpload = (field: keyof KYCData, e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      if (file.size > 10 * 1024 * 1024) { // 10MB limit
        toast.error("File size must be less than 10MB");
        return;
      }
      updateField(field, file);
      toast.success("Document uploaded successfully");
    }
  };

  const handleSubmit = () => {
    if (!validateStep(4)) return;
    
    setIsSubmitting(true);
    
    // Simulate API call
    setTimeout(() => {
      setIsSubmitting(false);
      toast.success("KYC verification submitted successfully!", {
        description: "Your application is under review. You'll be notified within 24-48 hours."
      });
      onComplete(kycData);
    }, 2000);
  };

  const idTypes = [
    { value: "passport", label: "Passport" },
    { value: "drivers-license", label: "Driver's License" },
    { value: "national-id", label: "National ID Card" },
    { value: "state-id", label: "State ID Card" },
  ];

  const countries = [
    "United States",
    "United Kingdom",
    "Canada",
    "Australia",
    "Germany",
    "France",
    "Spain",
    "Italy",
  ];

  return (
    <div className={`h-screen pb-0 overflow-y-auto ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'}`}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`sticky top-0 z-10 ${
          isDark 
            ? 'bg-gradient-to-br from-gray-800 to-gray-900' 
            : 'bg-gradient-to-br from-[#043b69] to-[#032d51]'
        } text-white p-6`}
      >
        <div className="flex items-center gap-4 max-w-md mx-auto mb-4">
          <motion.button
            whileTap={{ scale: 0.9 }}
            onClick={handleBack}
            className="p-2 hover:bg-white/10 rounded-full"
          >
            <ArrowLeft className="w-5 h-5" />
          </motion.button>
          <div className="flex-1">
            <h2>KYC Verification</h2>
            <p className="text-xs opacity-80">Step {currentStep} of {totalSteps}</p>
          </div>
          <Shield className="w-6 h-6" />
        </div>
        
        {/* Progress Bar */}
        <div className="max-w-md mx-auto">
          <Progress value={progress} className="h-2 bg-white/20" />
        </div>
      </motion.div>

      {/* Content */}
      <div className="max-w-md mx-auto p-6">
        {/* Info Banner */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          className="mb-6"
        >
          <Card className={`p-4 border-2 ${
            isDark 
              ? 'bg-blue-900/20 border-blue-700' 
              : 'bg-blue-50 border-blue-200'
          }`}>
            <div className="flex gap-3">
              <AlertCircle className="w-5 h-5 text-blue-600 dark:text-blue-400 mt-0.5 flex-shrink-0" />
              <div>
                <h4 className={`mb-1 ${isDark ? 'text-blue-200' : 'text-blue-800'}`}>
                  Why do we need this?
                </h4>
                <p className={`text-sm ${isDark ? 'text-blue-300' : 'text-blue-700'}`}>
                  KYC verification helps us comply with regulations and keep your account secure. 
                  Your information is encrypted and stored safely.
                </p>
              </div>
            </div>
          </Card>
        </motion.div>

        <AnimatePresence mode="wait">
          {/* Step 1: Personal Information */}
          {currentStep === 1 && (
            <motion.div
              key="step1"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
                <div className="flex items-center gap-3 mb-6">
                  <div className={`p-3 rounded-full ${isDark ? 'bg-blue-900/30' : 'bg-blue-100'}`}>
                    <User className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                  </div>
                  <div>
                    <h3 className={isDark ? 'text-white' : ''}>Personal Information</h3>
                    <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      Enter your legal name as it appears on your ID
                    </p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>First Name *</Label>
                    <Input
                      value={kycData.firstName}
                      onChange={(e) => updateField("firstName", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="Enter your first name"
                      required
                    />
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Last Name *</Label>
                    <Input
                      value={kycData.lastName}
                      onChange={(e) => updateField("lastName", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="Enter your last name"
                      required
                    />
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Date of Birth *</Label>
                    <div className="relative">
                      <Input
                        type="date"
                        value={kycData.dateOfBirth}
                        onChange={(e) => updateField("dateOfBirth", e.target.value)}
                        className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                        max={new Date(new Date().setFullYear(new Date().getFullYear() - 18)).toISOString().split('T')[0]}
                        required
                      />
                      <Calendar className={`absolute right-3 top-1/2 -translate-y-1/2 mt-1 w-4 h-4 pointer-events-none ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                    </div>
                    <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      You must be at least 18 years old
                    </p>
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Phone Number *</Label>
                    <Input
                      type="tel"
                      value={kycData.phoneNumber}
                      onChange={(e) => updateField("phoneNumber", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="+1 (555) 000-0000"
                      required
                    />
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Email Address</Label>
                    <Input
                      type="email"
                      value={kycData.email}
                      onChange={(e) => updateField("email", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="your.email@example.com"
                    />
                  </div>
                </div>
              </Card>
            </motion.div>
          )}

          {/* Step 2: Address Information */}
          {currentStep === 2 && (
            <motion.div
              key="step2"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
                <div className="flex items-center gap-3 mb-6">
                  <div className={`p-3 rounded-full ${isDark ? 'bg-blue-900/30' : 'bg-blue-100'}`}>
                    <MapPin className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                  </div>
                  <div>
                    <h3 className={isDark ? 'text-white' : ''}>Address Information</h3>
                    <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      Enter your current residential address
                    </p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Street Address *</Label>
                    <Input
                      value={kycData.streetAddress}
                      onChange={(e) => updateField("streetAddress", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="123 Main Street, Apt 4B"
                      required
                    />
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className={isDark ? 'text-gray-300' : ''}>City *</Label>
                      <Input
                        value={kycData.city}
                        onChange={(e) => updateField("city", e.target.value)}
                        className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                        placeholder="City"
                        required
                      />
                    </div>
                    <div>
                      <Label className={isDark ? 'text-gray-300' : ''}>State *</Label>
                      <Input
                        value={kycData.state}
                        onChange={(e) => updateField("state", e.target.value)}
                        className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                        placeholder="State"
                        required
                      />
                    </div>
                  </div>

                  <div className="grid grid-cols-2 gap-3">
                    <div>
                      <Label className={isDark ? 'text-gray-300' : ''}>ZIP Code *</Label>
                      <Input
                        value={kycData.zipCode}
                        onChange={(e) => updateField("zipCode", e.target.value)}
                        className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                        placeholder="12345"
                        required
                      />
                    </div>
                    <div>
                      <Label className={isDark ? 'text-gray-300' : ''}>Country *</Label>
                      <Select 
                        value={kycData.country} 
                        onValueChange={(value) => updateField("country", value)}
                      >
                        <SelectTrigger className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}>
                          <SelectValue />
                        </SelectTrigger>
                        <SelectContent className={isDark ? 'bg-gray-800 border-gray-700' : ''}>
                          {countries.map((country) => (
                            <SelectItem 
                              key={country} 
                              value={country}
                              className={isDark ? 'text-white focus:bg-gray-700' : ''}
                            >
                              {country}
                            </SelectItem>
                          ))}
                        </SelectContent>
                      </Select>
                    </div>
                  </div>
                </div>
              </Card>
            </motion.div>
          )}

          {/* Step 3: Identity Verification */}
          {currentStep === 3 && (
            <motion.div
              key="step3"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
                <div className="flex items-center gap-3 mb-6">
                  <div className={`p-3 rounded-full ${isDark ? 'bg-blue-900/30' : 'bg-blue-100'}`}>
                    <CreditCard className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                  </div>
                  <div>
                    <h3 className={isDark ? 'text-white' : ''}>Identity Verification</h3>
                    <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      Provide your government-issued ID details
                    </p>
                  </div>
                </div>

                <div className="space-y-4">
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>ID Type *</Label>
                    <Select 
                      value={kycData.idType} 
                      onValueChange={(value) => updateField("idType", value)}
                    >
                      <SelectTrigger className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}>
                        <SelectValue placeholder="Select ID type" />
                      </SelectTrigger>
                      <SelectContent className={isDark ? 'bg-gray-800 border-gray-700' : ''}>
                        {idTypes.map((type) => (
                          <SelectItem 
                            key={type.value} 
                            value={type.value}
                            className={isDark ? 'text-white focus:bg-gray-700' : ''}
                          >
                            {type.label}
                          </SelectItem>
                        ))}
                      </SelectContent>
                    </Select>
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>ID Number *</Label>
                    <Input
                      value={kycData.idNumber}
                      onChange={(e) => updateField("idNumber", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      placeholder="Enter your ID number"
                      required
                    />
                  </div>

                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>ID Expiry Date *</Label>
                    <Input
                      type="date"
                      value={kycData.idExpiry}
                      onChange={(e) => updateField("idExpiry", e.target.value)}
                      className={`mt-2 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
                      min={new Date().toISOString().split('T')[0]}
                      required
                    />
                    <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      Your ID must be valid for at least 6 months
                    </p>
                  </div>
                </div>
              </Card>
            </motion.div>
          )}

          {/* Step 4: Document Upload */}
          {currentStep === 4 && (
            <motion.div
              key="step4"
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              exit={{ opacity: 0, x: -20 }}
              transition={{ duration: 0.3 }}
            >
              <Card className={`p-6 shadow-md ${isDark ? 'bg-gray-800 border-gray-700' : ''}`}>
                <div className="flex items-center gap-3 mb-6">
                  <div className={`p-3 rounded-full ${isDark ? 'bg-blue-900/30' : 'bg-blue-100'}`}>
                    <FileText className={`w-5 h-5 ${isDark ? 'text-blue-400' : 'text-[#043b69]'}`} />
                  </div>
                  <div>
                    <h3 className={isDark ? 'text-white' : ''}>Upload Documents</h3>
                    <p className={`text-sm ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                      Please upload clear photos of your documents
                    </p>
                  </div>
                </div>

                <div className="space-y-4">
                  {/* ID Front Photo */}
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>ID Front Photo *</Label>
                    <motion.label
                      whileHover={{ scale: 1.01 }}
                      whileTap={{ scale: 0.99 }}
                      className={`mt-2 flex flex-col items-center justify-center p-6 border-2 border-dashed cursor-pointer transition-colors ${
                        kycData.idFrontPhoto
                          ? (isDark ? 'border-green-500 bg-green-900/20' : 'border-green-500 bg-green-50')
                          : (isDark ? 'border-gray-600 hover:border-blue-500 bg-gray-700/30' : 'border-gray-300 hover:border-[#043b69] bg-gray-50')
                      }`}
                    >
                      <input
                        type="file"
                        accept="image/*"
                        onChange={(e) => handleFileUpload("idFrontPhoto", e)}
                        className="hidden"
                      />
                      {kycData.idFrontPhoto ? (
                        <>
                          <CheckCircle className="w-8 h-8 text-green-500 mb-2" />
                          <p className={`text-sm ${isDark ? 'text-green-400' : 'text-green-700'}`}>
                            {kycData.idFrontPhoto.name}
                          </p>
                        </>
                      ) : (
                        <>
                          <Upload className={`w-8 h-8 mb-2 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                          <p className={isDark ? 'text-gray-300' : 'text-gray-600'}>
                            Upload front of ID
                          </p>
                          <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                            PNG, JPG up to 10MB
                          </p>
                        </>
                      )}
                    </motion.label>
                  </div>

                  {/* ID Back Photo */}
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>ID Back Photo (Optional)</Label>
                    <motion.label
                      whileHover={{ scale: 1.01 }}
                      whileTap={{ scale: 0.99 }}
                      className={`mt-2 flex flex-col items-center justify-center p-6 border-2 border-dashed cursor-pointer transition-colors ${
                        kycData.idBackPhoto
                          ? (isDark ? 'border-green-500 bg-green-900/20' : 'border-green-500 bg-green-50')
                          : (isDark ? 'border-gray-600 hover:border-blue-500 bg-gray-700/30' : 'border-gray-300 hover:border-[#043b69] bg-gray-50')
                      }`}
                    >
                      <input
                        type="file"
                        accept="image/*"
                        onChange={(e) => handleFileUpload("idBackPhoto", e)}
                        className="hidden"
                      />
                      {kycData.idBackPhoto ? (
                        <>
                          <CheckCircle className="w-8 h-8 text-green-500 mb-2" />
                          <p className={`text-sm ${isDark ? 'text-green-400' : 'text-green-700'}`}>
                            {kycData.idBackPhoto.name}
                          </p>
                        </>
                      ) : (
                        <>
                          <Upload className={`w-8 h-8 mb-2 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                          <p className={isDark ? 'text-gray-300' : 'text-gray-600'}>
                            Upload back of ID
                          </p>
                          <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                            PNG, JPG up to 10MB
                          </p>
                        </>
                      )}
                    </motion.label>
                  </div>

                  {/* Selfie Photo */}
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Selfie with ID *</Label>
                    <motion.label
                      whileHover={{ scale: 1.01 }}
                      whileTap={{ scale: 0.99 }}
                      className={`mt-2 flex flex-col items-center justify-center p-6 border-2 border-dashed cursor-pointer transition-colors ${
                        kycData.selfiePhoto
                          ? (isDark ? 'border-green-500 bg-green-900/20' : 'border-green-500 bg-green-50')
                          : (isDark ? 'border-gray-600 hover:border-blue-500 bg-gray-700/30' : 'border-gray-300 hover:border-[#043b69] bg-gray-50')
                      }`}
                    >
                      <input
                        type="file"
                        accept="image/*"
                        onChange={(e) => handleFileUpload("selfiePhoto", e)}
                        className="hidden"
                      />
                      {kycData.selfiePhoto ? (
                        <>
                          <CheckCircle className="w-8 h-8 text-green-500 mb-2" />
                          <p className={`text-sm ${isDark ? 'text-green-400' : 'text-green-700'}`}>
                            {kycData.selfiePhoto.name}
                          </p>
                        </>
                      ) : (
                        <>
                          <Camera className={`w-8 h-8 mb-2 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                          <p className={isDark ? 'text-gray-300' : 'text-gray-600'}>
                            Upload selfie holding ID
                          </p>
                          <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                            PNG, JPG up to 10MB
                          </p>
                        </>
                      )}
                    </motion.label>
                  </div>

                  {/* Address Proof */}
                  <div>
                    <Label className={isDark ? 'text-gray-300' : ''}>Proof of Address (Optional)</Label>
                    <motion.label
                      whileHover={{ scale: 1.01 }}
                      whileTap={{ scale: 0.99 }}
                      className={`mt-2 flex flex-col items-center justify-center p-6 border-2 border-dashed cursor-pointer transition-colors ${
                        kycData.addressProof
                          ? (isDark ? 'border-green-500 bg-green-900/20' : 'border-green-500 bg-green-50')
                          : (isDark ? 'border-gray-600 hover:border-blue-500 bg-gray-700/30' : 'border-gray-300 hover:border-[#043b69] bg-gray-50')
                      }`}
                    >
                      <input
                        type="file"
                        accept="image/*,.pdf"
                        onChange={(e) => handleFileUpload("addressProof", e)}
                        className="hidden"
                      />
                      {kycData.addressProof ? (
                        <>
                          <CheckCircle className="w-8 h-8 text-green-500 mb-2" />
                          <p className={`text-sm ${isDark ? 'text-green-400' : 'text-green-700'}`}>
                            {kycData.addressProof.name}
                          </p>
                        </>
                      ) : (
                        <>
                          <HomeIcon className={`w-8 h-8 mb-2 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
                          <p className={isDark ? 'text-gray-300' : 'text-gray-600'}>
                            Upload utility bill or bank statement
                          </p>
                          <p className={`text-xs mt-1 ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>
                            PDF, PNG, JPG up to 10MB
                          </p>
                        </>
                      )}
                    </motion.label>
                  </div>
                </div>
              </Card>
            </motion.div>
          )}
        </AnimatePresence>

        {/* Navigation Buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.2 }}
          className="mt-6 flex gap-3"
        >
          {currentStep < totalSteps ? (
            <Button
              onClick={handleNext}
              className={`flex-1 h-12 ${
                isDark 
                  ? 'bg-[#043b69] hover:bg-[#032d51]' 
                  : 'bg-[#043b69] hover:bg-[#032d51]'
              } text-white`}
            >
              Continue
              <ArrowRight className="w-4 h-4 ml-2" />
            </Button>
          ) : (
            <Button
              onClick={handleSubmit}
              disabled={isSubmitting}
              className={`flex-1 h-12 ${
                isDark 
                  ? 'bg-green-600 hover:bg-green-700' 
                  : 'bg-green-600 hover:bg-green-700'
              } text-white ${isSubmitting ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
              {isSubmitting ? (
                <div className="flex items-center gap-2">
                  <motion.div
                    animate={{ rotate: 360 }}
                    transition={{ duration: 1, repeat: Infinity, ease: "linear" }}
                    className="w-5 h-5 border-2 border-white border-t-transparent rounded-full"
                  />
                  Submitting...
                </div>
              ) : (
                <>
                  <CheckCircle className="w-4 h-4 mr-2" />
                  Submit for Verification
                </>
              )}
            </Button>
          )}
        </motion.div>
      </div>
    </div>
  );
}
