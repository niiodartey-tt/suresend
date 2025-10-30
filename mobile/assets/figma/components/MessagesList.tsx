import { motion } from "motion/react";
import { Search, ArrowLeft, X, MessageCircle } from "lucide-react";
import { Input } from "./ui/input";
import { Card } from "./ui/card";
import { Avatar, AvatarFallback } from "./ui/avatar";
import { Badge } from "./ui/badge";
import { useState } from "react";

interface MessagesListProps {
  onBack: () => void;
  onSelectChat: (chat: any) => void;
}

export function MessagesList({ onBack, onSelectChat }: MessagesListProps) {
  const [searchQuery, setSearchQuery] = useState("");

  const allChats = [
    {
      id: 1,
      name: "Sarah Johnson",
      lastMessage: "New escrow created: MacBook Pro M3",
      time: "2m ago",
      unread: 1,
      transactionId: "ESC-45823",
      avatar: "SJ",
      hasEscrowNotification: true,
    },
    {
      id: 2,
      name: "James Miller",
      lastMessage: "Transaction completed successfully!",
      time: "1d ago",
      unread: 0,
      transactionId: "ESC-45822",
      avatar: "JM",
    },
    {
      id: 3,
      name: "Mike Davis",
      lastMessage: "When will you ship the item?",
      time: "2d ago",
      unread: 0,
      transactionId: "ESC-45821",
      avatar: "MD",
    },
    {
      id: 4,
      name: "Emma Wilson",
      lastMessage: "Perfect, thanks!",
      time: "3d ago",
      unread: 0,
      transactionId: "ESC-45820",
      avatar: "EW",
    },
    {
      id: 5,
      name: "Robert Chen",
      lastMessage: "I have some concerns about the item",
      time: "4d ago",
      unread: 1,
      transactionId: "ESC-45819",
      avatar: "RC",
    },
  ];

  // Filter chats based on search
  const filteredChats = allChats.filter((chat) => 
    chat.name.toLowerCase().includes(searchQuery.toLowerCase()) ||
    chat.lastMessage.toLowerCase().includes(searchQuery.toLowerCase()) ||
    chat.transactionId.toLowerCase().includes(searchQuery.toLowerCase())
  );

  return (
    <div className="h-screen bg-[#F9FAFB] pb-24 overflow-y-auto">
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        className="sticky top-0 bg-white border-b border-gray-200 p-4 z-10"
      >
        <div className="max-w-md mx-auto">
          <div className="flex items-center gap-4 mb-4">
            <motion.button
              whileTap={{ scale: 0.9 }}
              onClick={onBack}
              className="p-2 hover:bg-gray-100 rounded-full"
            >
              <ArrowLeft className="w-5 h-5" />
            </motion.button>
            <h2>Messages</h2>
          </div>
          
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ delay: 0.1 }}
            className="relative"
          >
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 w-5 h-5 text-gray-400" />
            <Input
              placeholder="Search messages..."
              value={searchQuery}
              onChange={(e) => setSearchQuery(e.target.value)}
              className="pl-10 pr-10 bg-[#F9FAFB]"
            />
            {searchQuery && (
              <button
                onClick={() => setSearchQuery("")}
                className="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <X className="w-5 h-5" />
              </button>
            )}
          </motion.div>
        </div>
      </motion.div>

      <div className="max-w-md mx-auto p-6 space-y-3">
        {filteredChats.length === 0 ? (
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            className="text-center py-12"
          >
            <div className="w-16 h-16 bg-gray-100 rounded-full flex items-center justify-center mx-auto mb-4">
              <MessageCircle className="w-8 h-8 text-gray-400" />
            </div>
            <h3 className="mb-2">No messages found</h3>
            <p className="text-gray-500">
              {searchQuery 
                ? "Try a different search term" 
                : "Start a conversation from a transaction"}
            </p>
          </motion.div>
        ) : (
          filteredChats.map((chat, index) => (
          <motion.div
            key={chat.id}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ delay: index * 0.1 }}
            whileHover={{ scale: 1.02 }}
            whileTap={{ scale: 0.98 }}
            onClick={() => onSelectChat(chat)}
          >
            <Card className="p-4 cursor-pointer shadow-sm hover:shadow-md transition-shadow">
              <div className="flex items-start gap-3">
                <Avatar>
                  <AvatarFallback className="bg-blue-100 text-[#043b69]">
                    {chat.avatar}
                  </AvatarFallback>
                </Avatar>
                <div className="flex-1 min-w-0">
                  <div className="flex justify-between items-start mb-1">
                    <div>{chat.name}</div>
                    <span className="text-xs text-gray-500">{chat.time}</span>
                  </div>
                  <p className="text-gray-500 text-sm truncate mb-2">
                    {chat.lastMessage}
                  </p>
                  <Badge
                    variant="outline"
                    className="text-xs border-blue-200 text-blue-700"
                  >
                    {chat.transactionId}
                  </Badge>
                </div>
                {chat.unread > 0 && (
                  <motion.div
                    initial={{ scale: 0 }}
                    animate={{ scale: 1 }}
                    className="bg-[#043b69] text-white rounded-full w-6 h-6 flex items-center justify-center text-xs"
                  >
                    {chat.unread}
                  </motion.div>
                )}
              </div>
            </Card>
          </motion.div>
          ))
        )}
      </div>
    </div>
  );
}
