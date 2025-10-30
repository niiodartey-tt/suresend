import { motion } from "motion/react";
import { ArrowLeft, Send, Paperclip } from "lucide-react";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Input } from "./ui/input";
import { Button } from "./ui/button";
import { Badge } from "./ui/badge";
import { useState } from "react";

interface ChatScreenProps {
  chat: any;
  onBack: () => void;
}

export function ChatScreen({ chat, onBack }: ChatScreenProps) {
  const [message, setMessage] = useState("");

  // Show escrow notification if this is a new escrow chat
  const hasEscrowNotification = chat?.hasEscrowNotification || false;
  
  const baseMessages = [
    { id: 1, sender: "other", text: "Hi! I'm interested in this item.", time: "10:30 AM", type: "regular" },
    { id: 2, sender: "me", text: "Great! It's in perfect condition.", time: "10:32 AM", type: "regular" },
  ];
  
  const escrowMessages = hasEscrowNotification ? [
    { 
      id: 3, 
      sender: "system", 
      text: `🔒 Escrow Created\n\n${chat?.name || "User"} has created a new escrow transaction for ${chat?.transactionId || "this item"}. Funds are now secured in escrow until both parties confirm completion.`, 
      time: "10:35 AM",
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
    <div className="h-screen bg-[#F9FAFB] flex flex-col">
      {/* Header */}
      <motion.div
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        className="bg-white border-b border-gray-200 p-4"
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center gap-3 mb-3">
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={onBack}
              className="p-2 hover:bg-gray-100 rounded-full"
            >
              <ArrowLeft className="w-5 h-5" />
            </motion.button>
            <Avatar>
              <AvatarFallback className="bg-blue-100 text-[#043b69]">
                {chat?.avatar || "AS"}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1">
              <div>{chat?.name || "Alice Smith"}</div>
              <p className="text-xs text-gray-500">Online</p>
            </div>
          </div>
          <Badge variant="outline" className="border-blue-200 text-blue-700">
            {chat?.transactionId || "ESC-10234"}
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
                    ? "max-w-[85%] bg-blue-50 border-2 border-blue-200 text-blue-900 px-4 py-3"
                    : msg.sender === "me"
                      ? "max-w-[75%] bg-[#043b69] text-white rounded-2xl px-4 py-2"
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
            <div className="bg-white shadow-sm rounded-2xl px-4 py-3">
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
                    className="w-2 h-2 bg-gray-400 rounded-full"
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
        className="bg-white border-t border-gray-200 p-4"
      >
        <div className="max-w-md mx-auto flex items-center gap-2">
          <motion.button
            whileTap={{ scale: 0.9 }}
            className="p-2 hover:bg-gray-100 rounded-full"
          >
            <Paperclip className="w-5 h-5 text-gray-500" />
          </motion.button>
          <Input
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            onKeyPress={(e) => e.key === "Enter" && handleSend()}
            placeholder="Type a message..."
            className="flex-1"
          />
          <motion.div whileTap={{ scale: 0.9 }}>
            <Button
              onClick={handleSend}
              className="bg-[#043b69] hover:bg-[#032d51] rounded-full h-10 w-10 p-0"
            >
              <Send className="w-5 h-5" />
            </Button>
          </motion.div>
        </div>
      </motion.div>
    </div>
  );
}
