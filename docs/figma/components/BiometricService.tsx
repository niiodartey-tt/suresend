import { useState, useEffect, createContext, useContext, ReactNode } from 'react';

interface BiometricContextType {
  isAvailable: boolean;
  isEnrolled: boolean;
  authenticate: () => Promise<boolean>;
  enroll: () => Promise<boolean>;
  cancelAuthentication: () => void;
}

const BiometricContext = createContext<BiometricContextType | null>(null);

export const useBiometric = () => {
  const context = useContext(BiometricContext);
  if (!context) {
    throw new Error('useBiometric must be used within BiometricProvider');
  }
  return context;
};

interface BiometricProviderProps {
  children: ReactNode;
}

export const BiometricProvider = ({ children }: BiometricProviderProps) => {
  const [isAvailable, setIsAvailable] = useState(false);
  const [isEnrolled, setIsEnrolled] = useState(false);

  useEffect(() => {
    // Check if biometric authentication is available
    const checkAvailability = async () => {
      // Check for WebAuthn support
      if (window.PublicKeyCredential) {
        try {
          const available = await PublicKeyCredential.isUserVerifyingPlatformAuthenticatorAvailable();
          setIsAvailable(available);
          
          // Check if user has enrolled biometrics
          const enrolled = localStorage.getItem('biometric_enrolled') === 'true';
          setIsEnrolled(enrolled);
        } catch (error) {
          console.error('Error checking biometric availability:', error);
          setIsAvailable(false);
        }
      } else {
        setIsAvailable(false);
      }
    };

    checkAvailability();
  }, []);

  const generateChallenge = (): Uint8Array => {
    return new Uint8Array(32).map(() => Math.floor(Math.random() * 256));
  };

  const enroll = async (): Promise<boolean> => {
    if (!isAvailable) {
      return false;
    }

    try {
      const challenge = generateChallenge();
      
      const publicKeyCredentialCreationOptions: PublicKeyCredentialCreationOptions = {
        challenge,
        rp: {
          name: "Escrow Service",
          id: window.location.hostname,
        },
        user: {
          id: new Uint8Array(16),
          name: "user@example.com",
          displayName: "User",
        },
        pubKeyCredParams: [
          { alg: -7, type: "public-key" },  // ES256
          { alg: -257, type: "public-key" } // RS256
        ],
        authenticatorSelection: {
          authenticatorAttachment: "platform",
          userVerification: "required",
        },
        timeout: 60000,
        attestation: "none"
      };

      const credential = await navigator.credentials.create({
        publicKey: publicKeyCredentialCreationOptions
      });

      if (credential) {
        localStorage.setItem('biometric_enrolled', 'true');
        setIsEnrolled(true);
        return true;
      }
      
      return false;
    } catch (error) {
      console.error('Biometric enrollment failed:', error);
      return false;
    }
  };

  const authenticate = async (): Promise<boolean> => {
    if (!isAvailable || !isEnrolled) {
      return false;
    }

    try {
      const challenge = generateChallenge();
      
      const publicKeyCredentialRequestOptions: PublicKeyCredentialRequestOptions = {
        challenge,
        timeout: 60000,
        userVerification: "required",
        rpId: window.location.hostname,
      };

      const credential = await navigator.credentials.get({
        publicKey: publicKeyCredentialRequestOptions
      });

      return credential !== null;
    } catch (error) {
      console.error('Biometric authentication failed:', error);
      return false;
    }
  };

  const cancelAuthentication = () => {
    // In a real implementation, you would cancel any pending authentication requests
    console.log('Biometric authentication cancelled');
  };

  const value = {
    isAvailable,
    isEnrolled,
    authenticate,
    enroll,
    cancelAuthentication,
  };

  return (
    <BiometricContext.Provider value={value}>
      {children}
    </BiometricContext.Provider>
  );
};
