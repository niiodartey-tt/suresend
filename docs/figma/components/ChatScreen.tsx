import { motion } from "motion/react";
import { ArrowLeft, Send, Paperclip } from "lucide-react";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { useState } from "react";
import { useTheme } from "./ThemeContext";

interface ChatScreenProps {
  chat: any;
  onBack: () => void;
  recentTransaction?: any;
}

export function ChatScreen({ chat, onBack, recentTransaction }: ChatScreenProps) {
  const { isDark } = useTheme();
  const [message, setMessage] = useState("");

  // Show escrow notification if this is a new escrow chat or if there's a recent transaction
  const hasEscrowNotification = chat?.hasEscrowNotification || !!recentTransaction;
  
  const baseMessages = [
    { id: 1, sender: "other", text: "Hi! I'm interested in this item.", time: "10:30 AM", type: "regular" },
    { id: 2, sender: "me", text: "Great! It's in perfect condition.", time: "10:32 AM", type: "regular" },
  ];
  
  const escrowMessages = hasEscrowNotification ? [
    { 
      id: 3, 
      sender: "system", 
      text: `🔒 Escrow Created\n\n${recentTransaction?.name || chat?.name || "User"} has created a new escrow transaction ${recentTransaction?.id || chat?.transactionId || ""}. Amount: $${recentTransaction?.amount || chat?.amount || "0.00"}. Funds are now secured in escrow until both parties confirm completion.`, 
      time: "Just now",
      type: "escrow"
    },
  ] : [];
  
  const regularMessages = [
    { id: 4, sender: "other", text: "I've sent the payment to escrow.", time: "10:35 AM", type: "regular" },
    { id: 5, sender: "me", text: "Perfect! I'll ship it today.", time: "10:36 AM", type: "regular" },
    { id: 6, sender: "other", text: "When can I expect delivery?", time: "10:38 AM", type: "regular" },
    { id: 7, sender: "me", text: "Should arrive in 2-3 business days.", time: "10:40 AM", type: "regular" },
  ];
  
  const messages = [...baseMessages, ...escrowMessages, ...regularMessages];

  const handleSend = () => {
    if (message.trim()) {
      setMessage("");
    }
  };

  return (
    <div className={`h-screen ${isDark ? 'bg-gray-900' : 'bg-[#F9FAFB]'} flex flex-col`}>
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`${isDark ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-b p-4`}
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center gap-3 mb-3">
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={onBack}
              className={`p-2 rounded-full ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
            >
              <ArrowLeft className="w-5 h-5" />
            </motion.button>
            <Avatar>
              <AvatarFallback className={`${isDark ? 'bg-blue-900/30 text-blue-300' : 'bg-blue-100 text-[#043b69]'}`}>
                {chat?.avatar || "AS"}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <div className={isDark ? 'text-white' : ''}>{chat?.name || "Alice Smith"}</div>
              <p className={`text-xs ${isDark ? 'text-gray-400' : 'text-gray-500'}`}>Online</p>
            </div>
          </div>
          <Badge variant="outline" className={`${isDark ? 'border-blue-700 text-blue-300' : 'border-blue-200 text-blue-700'}`}>
            {recentTransaction?.id || chat?.transactionId || "ESC-10234"}
          </Badge>
        </div>
      </motion.div>

      {/* Messages */}
      <div className="flex-1 overflow-y-auto p-4">
        <div className="max-w-md mx-auto space-y-4">
          {messages.map((msg, index) => (
            <motion.div
              key={msg.id}
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: index * 0.05 }}
              className={`flex ${
                msg.type === "escrow" 
                  ? "justify-center" 
                  : msg.sender === "me" 
                    ? "justify-end" 
                    : "justify-start"
              }`}
            >
              <div
                className={`${
                  msg.type === "escrow"
                    ? isDark 
                      ? "max-w-[85%] bg-blue-900/30 border-2 border-blue-700 text-blue-200 px-4 py-3"
                      : "max-w-[85%] bg-blue-50 border-2 border-blue-200 text-blue-900 px-4 py-3"
                    : msg.sender === "me"
                      ? isDark
                        ? "max-w-[75%] bg-blue-600 text-white rounded-2xl px-4 py-2"
                        : "max-w-[75%] bg-[#043b69] text-white rounded-2xl px-4 py-2"
                      : isDark
                        ? "max-w-[75%] bg-gray-800 border border-gray-700 shadow-sm rounded-2xl px-4 py-2 text-white"
                        : "max-w-[75%] bg-white shadow-sm rounded-2xl px-4 py-2"
                }`}
              >
                <p className="whitespace-pre-line">{msg.text}</p>
                <p className={`text-xs mt-1 ${
                  msg.type === "escrow"
                    ? "text-blue-700 text-center"
                    : msg.sender === "me" 
                      ? "text-white/70" 
                      : "text-gray-500"
                }`}>
                  {msg.time}
                </p>
              </div>
            </motion.div>
          ))}
          
          {/* Typing Indicator */}
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            className="flex justify-start"
          >
            <div className={`${isDark ? 'bg-gray-800 border border-gray-700' : 'bg-white'} shadow-sm rounded-2xl px-4 py-3`}>
              <div className="flex gap-1">
                {[0, 1, 2].map((i) => (
                  <motion.div
                    key={i}
                    animate={{ y: [0, -5, 0] }}
                    transition={{
                      duration: 0.6,
                      repeat: Infinity,
                      delay: i * 0.2,
                    }}
                    className={`w-2 h-2 ${isDark ? 'bg-gray-500' : 'bg-gray-400'} rounded-full`}
                  />
                ))}
              </div>
            </div>
          </motion.div>
        </div>
      </div>

      {/* Input */}
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className={`${isDark ? 'bg-gray-800 border-gray-700' : 'bg-white border-gray-200'} border-t p-4`}
      >
        <div className="max-w-md mx-auto flex items-center gap-2">
          <motion.button
            whileTap={{ scale: 0.9 }}
            className={`p-2 rounded-full ${isDark ? 'hover:bg-gray-700' : 'hover:bg-gray-100'}`}
          >
            <Paperclip className={`w-5 h-5 ${isDark ? 'text-gray-400' : 'text-gray-500'}`} />
          </motion.button>
          <Input
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyPress={(e) => e.key === "Enter" && handleSend()}
            placeholder="Type a message..."
            className={`flex-1 ${isDark ? 'bg-gray-700 border-gray-600 text-white' : ''}`}
          />
          <motion.div whileTap={{ scale: 0.9 }}>
            <Button
              onClick={handleSend}
              className={`rounded-full h-10 w-10 p-0 ${
                isDark 
                  ? 'bg-blue-600 hover:bg-blue-700' 
                  : 'bg-[#043b69] hover:bg-[#032d51]'
              }`}
            >
              <Send className="w-5 h-5" />
            </Button>
          </motion.div>
        </div>
      </motion.div>
    </div>
  );
}
