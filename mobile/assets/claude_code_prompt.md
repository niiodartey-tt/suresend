# Comprehensive Prompt for Building Escrow Mobile Application

## Project Overview
Build a complete mobile-first escrow transaction application using React Native (or React with mobile-responsive design). The application must replicate the **EXACT** design, layout, colors, spacing, typography, and functionality shown in the provided 35 screenshots.

---

## 🎨 CRITICAL DESIGN REQUIREMENTS

### Color Palette (Extract exact colors from images)
- **Primary Navy Blue**: `#0A2647` (header backgrounds, primary buttons)
- **Secondary Blue**: `#144272` (accents, secondary elements)
- **Light Blue**: `#205295` (button hover states, badges)
- **Muted Blue**: `#7B96B0` (disabled states, borders)
- **Success Green**: `#00C853` (completed status, success icons)
- **Warning Orange**: `#FF9800` (dispute status, warnings)
- **Error Red**: `#E53935` (errors, delete actions)
- **Background Gray**: `#F5F7FA` (page backgrounds)
- **Card White**: `#FFFFFF` (cards, modals)
- **Text Primary**: `#1A1A1A` (headings, labels)
- **Text Secondary**: `#666666` (descriptions, helper text)

### Typography
- **Font Family**: Use 'Inter', 'SF Pro Display', or 'Roboto'
- **Font Weights**: 
  - Regular (400) for body text
  - Medium (500) for labels
  - Semibold (600) for subheadings
  - Bold (700) for headings
- **Font Sizes**:
  - Large headings: 24px-28px
  - Page titles: 20px-22px
  - Section headers: 16px-18px
  - Body text: 14px-15px
  - Small text: 12px-13px
  - Tiny text: 10px-11px

### Spacing & Layout
- **Screen padding**: 16px-20px horizontal
- **Card padding**: 16px-20px all sides
- **Section spacing**: 20px-24px between sections
- **Element spacing**: 12px-16px between related elements
- **Border radius**: 
  - Small elements (buttons, badges): 6px-8px
  - Cards: 12px-16px
  - Modals: 16px-20px

### Icons & Graphics
- Use **Feather Icons**, **Lucide React**, or **Heroicons**
- Icon sizes: 20px-24px for regular icons, 16px-18px for small icons
- Success icon: Green circular checkmark with glow effect
- Lock icons, shield icons, dollar signs, etc. - match exact visual style

---

## 📱 APPLICATION STRUCTURE

### Bottom Navigation (Always Visible)
Located at bottom of screen with 5 tabs:
1. **Dashboard** - Grid icon - Default active
2. **Deals** - Document/list icon
3. **Create** (center) - Large circular "+" button, elevated
4. **Settings** - Gear icon
5. **Profile** - User icon

Active state: Blue background fill, white icon
Inactive state: Gray icon, no background

---

## 🔐 AUTHENTICATION FLOW

### 1. Login Page (`login.png`)
**File Reference**: `login.png`

**Layout**:
- Navy blue header section (top 30% of screen)
  - White text: "Welcome Back"
  - White subtext: "Sign in to continue"
- White form section (bottom 70%)
  - **Email Address** field
    - Label above input
    - Email icon on left side of input
    - Light gray border, rounded corners
    - Placeholder: "your@email.com"
  - **Password** field
    - Label above input
    - Lock icon on left side
    - Eye icon on right (show/hide password)
    - Password dots display
  - **Remember me** checkbox (left) | **Forgot Password?** link (right, blue)
  - **Sign In** button
    - Full width
    - Navy blue background
    - White text
    - 48px height
  - Bottom text: "Don't have an account? **Sign Up**" (Sign Up is blue link)

**Validation**:
- Email field: Validate email format
- Password field: Minimum 6 characters
- Show error states with red borders and error messages

---

### 2. OTP Verification Modal (`login_otp_popup.png`)
**File Reference**: `login_otp_popup.png`

**Modal Overlay**:
- Dark semi-transparent background (rgba(0,0,0,0.5))
- Centered white card with rounded corners

**Modal Content**:
- **Header** (navy blue bar):
  - Mail icon (white)
  - "Verify OTP" title
  - "Enter the code sent to your email" subtitle
  - Close X button (top right)
- **Body** (white):
  - "Code sent to" label
  - Email display: "7ountor@gmail.com"
  - Helper text: "Please check your email inbox for the verification code"
  - **OTP Input**: 6-digit code entry field (large input boxes or single field)
  - Demo text: "For demo purposes, use OTP: 123456" (gray, small)
  - "Resend OTP in 55s" (clickable after countdown)
  - **Verify** button (light blue, full width)
  - **Cancel** button (white/gray outline, full width)

**Behavior**:
- Auto-focus on OTP input when modal opens
- Enable Verify button only when 6 digits entered
- Countdown timer for resend (55 seconds)
- Close modal on Cancel or X click

---

### 3. Sign Up Page (`sign_up.png`)
**File Reference**: `sign_up.png`

**Layout**:
- Navy blue header:
  - Back arrow (top left)
  - "Create Account" title
  - "Join us today" subtitle
- White form section with fields:
  - **Full Name**
    - User icon left
    - Placeholder: "John Doe"
  - **Username**
    - @ icon left
    - Placeholder: "johndoe"
    - Helper text: "This will be used for transactions"
  - **Email Address**
    - Email icon left
    - Placeholder: "your@email.com"
  - **Phone Number**
    - Phone icon left
    - Placeholder: "+1 (234) 567-8900"
    - Helper text: "Can also be used for transactions"
  - **Password**
    - Lock icon left
    - Eye icon right
    - Masked input
  - **Confirm Password**
    - Lock icon left
    - Eye icon right
    - Masked input
  - **Checkbox**: "I agree to the **Terms of Service** and **Privacy Policy**" (links are blue)
  - **Create Account** button (navy blue, full width)
  - Bottom: "Already have an account? **Sign In**" (blue link)

**Validation**:
- All fields required
- Email format validation
- Phone number format validation
- Password match validation
- Terms checkbox must be checked

---

### 4. Forgot Password Page (`forgot_password.png`)
**File Reference**: `forgot_password.png`

**Layout**:
- Navy blue header:
  - Back arrow (top left)
  - "Forgot Password?" title
  - "No worries, we'll send you reset instructions" subtitle
- White section:
  - **Email Address** field
    - Email icon left
    - Placeholder: "your@email.com"
    - Helper text: "Enter the email associated with your account"
  - **Send Reset Link** button (navy blue, full width)
  - "← Back to Login" link (centered, blue)

---

## 🎯 ONBOARDING SCREENS

### Onboarding 1 (`onboarding_1.png`)
**Layout**:
- **Skip** button (top right corner, gray text)
- Large icon/illustration: Shield icon in light gray square
- **"Secure Escrow"** heading (centered, bold)
- Description text: "Your funds are protected in secure escrow until both parties confirm the transaction"
- **Pagination dots**: 3 dots at bottom (first one filled/active)
- **Next →** button (navy blue, full width, bottom)

### Onboarding 2 (`onboarding_2.png`)
**Layout**:
- **Skip** button (top right)
- Large icon: Lock/padlock icon in mint green square
- **"Safe & Encrypted"** heading
- Description: "Bank-level encryption and security measures to keep your money and data safe"
- **Pagination dots**: 3 dots (second one active)
- **Next →** button

### Onboarding 3 (`onboarding_3.png`)
**Layout**:
- **Skip** button (top right)
- Large icon: Lightning bolt icon in orange/yellow square
- **"Fast Transactions"** heading
- Description: "Quick and easy transactions with real-time updates and instant notifications"
- **Pagination dots**: 3 dots (third one active)
- **Get Started →** button (navy blue, full width)

**Behavior**:
- Swipeable screens (left/right)
- Skip button goes to login/signup
- Auto-advance option (5 seconds per screen)
- Get Started leads to Sign Up or Login

---

## 🏠 DASHBOARD PAGE

### Dashboard Main (`dashboard.png`)
**File Reference**: `dashboard.png`

**Header Section** (navy blue background):
- "Welcome back," (light text)
- "John Doe" (large, white, bold)
- Notification bell icon (top right, with red badge showing "3+")

**Balance Cards** (side by side):
1. **Wallet Balance**
   - Label: "Wallet Balance"
   - Amount: "$4,500.00" (large, white)
2. **Escrow Balance**
   - Label: "Escrow Balance"
   - Amount: "$200.00" (large, white)

**Stats Card** (white card with 4 quadrants):
- **Active**: 2 (with layers icon, blue)
- **Completed**: 0 (with checkmark icon, green)
- **Dispute**: 1 (with warning icon, orange)
- **Total**: 2 (with trophy/medal icon, purple)

**Action Buttons** (full width, side by side):
- **+ Top up wallet** (outlined button, navy border)
- **Withdraw** (filled button, navy background, white text)

**Recent Transactions Section**:
- Header: "RECENT TRANSACTIONS" (gray, uppercase)
- Subheader: "October" (date grouping)
- Filter icon (top right)
- "See all" link (top right, blue)

**Transaction Card 1**:
- Transaction ID: "ESC-45823" (top left, gray)
- Status badge: "In Escrow" (top right, light blue pill)
- Date: "Oct 28, 2025"
- Amount: "$850.00" (large, bold)
- Description: "MacBook Pro M3"
- Seller info: "Seller: Sarah Johnson"
- **Details** button (outlined, navy border)

**Transaction Card 2**:
- Transaction ID: "ESC-45822"
- Status badge: "Completed" (green pill)
- Date: "Oct 27, 2025"
- [Partial view]

**Bottom Navigation** (active on Dashboard)

---

### Dashboard with Filter (`dashboard_filter.png`)
**File Reference**: `dashboard_filter.png`

Same as dashboard but with:
- **Search bar** at top: "Search transactions..." with search icon
- **Filter tabs** below search:
  - "All" (active - navy background)
  - "In Escrow" (inactive)
  - "Completed" (inactive)
  - "In Progress" (inactive)
  - "Disputed" (inactive)

---

## 💼 DEALS PAGE

### My Deals (`deals.png`)
**File Reference**: `deals.png`

**Header**:
- "My Deals" title
- Filter icon (top right)

**Search bar**:
- "Search deals..." placeholder
- Search icon left

**Deal Cards** (vertical list):

**Deal Card 1**:
- Box/package icon (left, blue circular background)
- **"MacBook Pro M3"** (title, bold)
- Transaction ID: "ESC-45823" (below title, small gray)
- Status: "In Escrow" (blue pill badge)
- Amount: "-$850" (right side, red - indicating purchase)
- Date: "Oct 28, 2025"
- "Seller: Sarah Johnson" (small gray text)
- Left border: Blue vertical line

**Deal Card 2**:
- Code/development icon (left, green circular background)
- **"Web Development Service"** (title)
- Transaction ID: "ESC-45822"
- Status: "Completed" (green pill badge)
- Amount: "+$1200" (right side, green - indicating sale)
- Date: "Oct 27, 2025"
- "Buyer: James Miller"
- Left border: Green vertical line

**Deal Card 3**:
- Gaming controller icon (left, green circular background)
- **"Gaming Console Bundle"**
- Transaction ID: "ESC-45821"
- Status: "In Progress" (yellow pill badge)
- Amount: "+$450" (green)
- Date: "Oct 26, 2025"
- "Buyer: Mike Davis"
- Left border: Yellow vertical line

**Deal Card 4**:
- Design icon (left, blue circular background)
- **"Graphic Design Package"**
- Transaction ID: "ESC-45820"
- Status: "Buying" (blue pill)
- Amount: "-$2500" (red)
- Date: "Oct 25, 2025"
- "Seller: Emma Wilson"
- Left border: Blue vertical line

**Bottom Navigation** (active on Deals)

---

## 📊 TRANSACTION DETAILS

### Transaction Details Pages (`transaction_details.png`, `transaction_details_2.png`, `transaction_details_3.png`)
**File References**: All 3 transaction_details files

**Header** (navy blue):
- Back arrow (left)
- "Transaction Details" title
- Transaction ID: "ESC-45823" (subtitle)

**Product Info Card** (white):
- **"MacBook Pro M3"** (large, bold)
- Status badge: "In Escrow" (blue pill, top right)
- Description: "Brand new MacBook Pro 14-inch with M3 chip"

**Amount Section**:
- "Amount" label
- "$850.00" (large, bold)
- "Created" label
- "Oct 28, 2025" (date)

**Transaction Progress** (white card):
- "Transaction Progress" header
- "50%" percentage (right)
- Blue progress bar (50% filled)

**Progress Steps** (vertical timeline):
1. ✅ **Initiated** - "Oct 24, 2025 10:30 AM" (completed - green checkmark)
2. ✅ **In Escrow** - "Oct 24, 2025 10:35 AM" (completed - green checkmark)
3. ⬜ **Delivered** (pending - gray empty square)
4. ⬜ **Completed** (pending - gray empty square)

**Participants Card**:
- "Participants" header
- **Buyer**: "JD" avatar (navy circle), "John Doe", "You" badge (gray pill)
- **Seller**: "AS" avatar (mint green circle), "Sarah Johnson", "Message" button (blue text)

**Payment Details Card**:
- "Payment Details" header
- **Transaction Amount**: $850.00
- **Escrow Fee (1%)**: $8.50
- **Total Amount**: $858.50 (bold)
- **Payment Method**: Card ending in 4242

**Additional Details Card**:
- "Additional Details" header
- **Category**: Physical Product
- **Expected Delivery**: Nov 2, 2025

**Terms & Conditions** (expandable section):
- "Terms & Conditions" header with chevron
- Content: "Item must be as described. Buyer has 3 days to inspect and confirm receipt. Seller must ship within 2 business days of escrow confirmation."

**Activity Log** (white card):
- "Activity Log" header
- Timeline list:
  - "Transaction created" - "Oct 24, 2025 10:30 AM • You"
  - "Funds deposited to escrow" - "Oct 24, 2025 10:35 AM • System"
  - "Seller notified" - "Oct 24, 2025 10:36 AM • System"

**Action Buttons** (bottom):
- **Download Receipt** button (outlined)
- **Confirm & Release Funds** button (navy blue, full width)
- **Raise Dispute** button (red outline)
- **Secure Escrow Protection** info box (light blue background):
  - Info icon
  - "Your funds are held securely in escrow until both parties confirm the transaction"

**Bottom Navigation** (Deals active since we came from there)

---

## 💬 MESSAGE/CHAT PAGE

### Chat Interface (`message_chat.png`)
**File Reference**: `message_chat.png`

**Header** (navy blue):
- Back arrow (left)
- "AS" avatar circle (mint green)
- "MacBook Pro M3" (title)
- "Online" status (green dot + text)
- Transaction ID: "ESC-10234" (link, top right, small blue text)

**Chat Messages** (scrollable):

**Incoming message** (left-aligned, light gray bubble):
- "Hi! I'm interested in this item."
- Timestamp: "10:30 AM"

**Outgoing message** (right-aligned, navy blue bubble, white text):
- "Great! It's in perfect condition."
- Timestamp: "10:32 AM"

**Incoming message**:
- "I've sent the payment to escrow."
- Timestamp: "10:35 AM"

**Outgoing message**:
- "Perfect! I'll ship it today."
- Timestamp: "10:36 AM"

**Incoming message**:
- "When can I expect delivery?"
- Timestamp: "10:38 AM"

**Outgoing message**:
- "Should arrive in 2-3 business days."
- Timestamp: "10:40 AM"

**Typing indicator** (left side):
- Three animated dots in gray bubble

**Message Input Bar** (bottom):
- Attachment/paperclip icon (left)
- Text input: "Type a message..." (placeholder)
- Send button (navy blue circle with white arrow icon, right)

---

## 💰 WALLET & TRANSACTIONS

### Wallet Page (`top_up.png`)
**File Reference**: `top_up.png`

**Header** (navy blue):
- Back arrow (left)
- "Wallet" title

**Balance Card** (navy blue):
- Wallet icon (white)
- "My Wallet" label
- "Available Balance" label
- "$4,500" (large, white, bold)
- Row below:
  - "Escrow Balance": "$200"
  - "Total": "$4,700"

**Action Buttons**:
- **Top Up Wallet** (navy blue button)
- **Withdraw Funds** (white button with navy outline)

**Transaction History Section**:
- "Transaction History" header

**Transaction List**:
1. **Escrow Created - ESC-45823**
   - Date: "Oct 28, 2025"
   - Amount: "+$850" (green)
   - Icon: Green arrow down in circle

2. **Transaction Completed - ESC-45822**
   - Date: "Oct 27, 2025"
   - Amount: "+$1200" (green)
   - Icon: Green checkmark in circle

3. **Escrow Payment - ESC-45821**
   - Date: "Oct 26, 2025"
   - Amount: "-$680" (red)
   - Icon: Red arrow up in circle

4. **Transaction Completed - ESC-45818**
   - Date: "Oct 23, 2025"
   - Amount: "+$1800" (green)

5. **Transaction Completed - ESC-45817**
   - Date: "Oct 22, 2025"
   - Amount: "+$3200" (green)

6. **Wallet Top Up**
   - Date: "Oct 21, 2025"
   - Amount: "+$1000" (green)

7. **Transaction Completed - ESC-45814**
   - Date: "Oct 19, 2025"
   - Amount: "+$750" (green)

8. **Withdrawal to Bank**
   - Date: "Oct 18, 2025"
   - Amount: "-$500" (red)

---

### Fund Wallet Pages (`fund_wallet.png`, `fund_wallet_2.png`)
**File References**: `fund_wallet.png`, `fund_wallet_2.png`

**Header** (navy blue):
- Back arrow
- "Fund Wallet" title

**Balance Display** (light blue info box):
- "Available Balance: $4,500"

**Amount Input**:
- "Amount to Add" label
- Large dollar amount input: "889"
- Number pad or keyboard

**Payment Method Selection**:
- "Select Payment Method" header

**Payment Options** (radio buttons):
1. **Card Payment**
   - Credit card icon (blue)
   - Radio button (unselected)

2. **Mobile Money** ✓
   - Phone icon (green)
   - Radio button (selected - filled navy circle)

3. **Bank Transfer**
   - Building icon (purple)
   - Radio button (unselected)

**Payment Details** (if Mobile Money selected):
- "Phone Number" field
- Display: "+1 (234) 567-8900"

**Confirm Payment** button (navy blue, full width, bottom)

---

### Withdraw Funds Page (`withdraw_funds.png`)
**File Reference**: `withdraw_funds.png`

**Header** (navy blue):
- Back arrow
- "Withdraw Funds" title

**Balance Display** (light blue info box):
- "Available Balance: $4,500"

**Form Fields**:
1. **Withdrawal Amount**
   - Label: "Withdrawal Amount"
   - Input: "0.00" (placeholder with dollar sign)

2. **Withdrawal Method**
   - Dropdown: "Select method" (placeholder)

3. **Account Number**
   - Input: "Enter account number" (placeholder)

4. **Account Holder Name**
   - Input: "John Doe" (pre-filled, read-only or editable)

**Confirm Withdrawal** button (navy blue, full width, disabled until form complete)

---

## ⚙️ SETTINGS & PROFILE

### Settings Page (`settings.png`, `setting_2.png`)
**File References**: Both settings files

**Header** (navy blue):
- Back arrow
- "Settings" title
- "Manage your preferences" subtitle

**Appearance Section**:
- "Appearance" header (gray, uppercase, small)
- **Dark Mode** toggle
  - Sun icon (left)
  - "Switch to dark theme" (description)
  - Toggle switch (right, off position - gray)

**Notifications Section**:
- "Notifications" header
- **Push Notifications** toggle
  - Phone icon
  - "Get real-time push notifications"
  - Toggle switch (off)
- **Email Alerts** toggle
  - Bell icon
  - "Receive email updates"
  - Toggle switch (ON - navy blue)

**Security Section**:
- "Security" header
- **Two-Factor Authentication**
  - Shield icon
  - "Add extra security layer"
  - Toggle switch (off)
- **Biometric Login**
  - Fingerprint icon
  - "Use fingerprint/face ID"
  - Toggle switch (off)

**Preferences Section**:
- "Preferences" header
- **Language**
  - Globe icon
  - "English"
  - Right chevron (→)
- **Currency**
  - Wallet/card icon
  - "USD"
  - Right chevron

**Help & Support Section**:
- "Help & Support" header
- **Help Center**
  - Question mark icon
  - Right chevron
- **Privacy Policy**
  - Document icon
  - Right chevron

**Logout**:
- Red **Logout** button with logout icon
- Full width, outlined in red

**Toast Notification** (bottom of screen):
- "Payment Received" with checkmark icon
- Green background
- Fades in/out

---

### Dark Mode Settings (`dark_mode_eneabled.png`)
**File Reference**: `dark_mode_eneabled.png`

Same layout as Settings but with:
- Dark navy/black background
- White text
- Dark cards with lighter navy borders
- **Dark Mode** toggle ON (blue)
- Toast at bottom: "Dark mode enabled" (green background, white text)

**Color scheme for dark mode**:
- Background: `#0A1929`
- Card background: `#132F4C`
- Text: `#FFFFFF`
- Secondary text: `#B2BAC2`
- Borders: `#1E3A5F`

---

### Profile Page (`profile.png`)
**File Reference**: `profile.png`

**Header** (navy blue):
- Back arrow (left)
- "Profile" title
- Settings gear icon (top right)

**Profile Card** (white):
- **Avatar**: "JD" in navy circle (large, centered)
- Blue checkmark badge (verified)
- **Name**: "John Doe" (large, bold)
- **Username**: "@johndoe" (gray)
- **Verified** badge (blue pill)
- **Member since Jan 2024** (small gray text)
- **Bio**: "Professional buyer and seller on the platform. Specializing in electronics and tech products."
- **User ID**: "ESC-USER-10234567" (with copy icon)

**Balance Card** (navy blue):
- Dollar icon
- "Total Balance" label with eye icon (show/hide)
- **$4700.00** (large, white)
- Row below:
  - "Available": "$4500.00"
  - "In Escrow": "$200.00"

**Action Buttons** (2 columns):
- **Package icon button** (left, outlined)
- **Chart/growth icon button** (right, outlined)

**Bottom Navigation** (Profile active)

---

### Edit Profile Pages (`edit_profile.png`, `edit_profile_2.png`)
**File References**: Both edit_profile files

**Header** (white):
- Back arrow (left)
- "Edit Profile" title
- **Save** button (top right, navy blue)

**Profile Picture Section**:
- Large "JD" avatar circle (navy)
- Camera icon badge (bottom right of avatar)
- "Click to change profile picture" text (centered below)

**Personal Information Section** (white card):
- Section icon + "Personal Information" header

**Form Fields**:
1. **Full Name**
   - Label: "Full Name"
   - Value: "John Doe"

2. **Username**
   - Label: "Username"
   - Value: "@johndoe"
   - Helper: "Your unique username on the platform"

3. **Bio**
   - Label: "Bio"
   - Value: "Professional buyer and seller on the platform. Specializing in electronics and tech products."
   - Multi-line textarea

**Contact Information Section** (white card):
- Envelope icon + "Contact Information" header

**Form Fields**:
1. **Email Address**
   - Label: "Email Address"
   - Value: "john.doe@example.com"

2. **Phone Number**
   - Label: "Phone Number"
   - Value: "+1 (234) 567-8900"

3. **Location**
   - Label: "Location"
   - Location pin icon + "New York, USA"

**Save Changes** button (navy blue, full width, bottom)

---

## 📬 NOTIFICATIONS PAGE

### Notifications (`notification.png`)
**File Reference**: `notification.png`

**Header** (navy blue):
- Back arrow (left)
- "Notifications" title
- "7 unread" subtitle
- Filter icon (top right)

**Search Bar**:
- "Search notifications..." placeholder
- Search icon left

**Notification Cards** (vertical list, newest first):

**Notification 1**:
- Info icon (blue circle, left)
- Blue dot indicator (unread)
- **"Transaction Updated"** (bold)
- "ESC-45823 - MacBook Pro M3 is now in progress"
- "Just now" (timestamp, gray)

**Notification 2**:
- Dollar icon (purple circle)
- Blue dot (unread)
- **"Payment Received"**
- "$576.83 added to your wallet"
- "Just now"

**Notification 3**:
- Dollar icon (purple circle)
- Blue dot (unread)
- **"Payment Received"**
- "$428.99 added to your wallet"
- "Just now"

**Notification 4**:
- Info icon (blue circle)
- Blue dot (unread)
- **"New Message"**
- "You have a new message from a transaction partner"
- "Just now"

**Notification 5**:
- Checkmark icon (green circle)
- Blue dot (unread)
- **"New Escrow Created"**
- "ESC-45823 - MacBook Pro M3 escrow created with Sarah Johnson"
- "2m ago"

All cards have:
- Left border matching icon color
- White background
- Slight shadow
- Tap to view detail

---

## 🔨 CREATE TRANSACTION FLOWS

### Create Transaction Modal (`create_transaction_button.png`)
**File Reference**: `create_transaction_button.png`

**Modal** (appears over Settings page):
- Semi-transparent dark overlay
- White rounded modal card (bottom sheet style or centered)
- Close X button (top right)

**Content**:
- "Create Transaction" title (bold)
- "Choose whether you want to buy or sell" subtitle (gray)

**Options** (2 large cards):

1. **Buy** (outlined card)
   - Shopping cart icon (blue)
   - "Buy" (bold)
   - "I want to purchase something" (description)
   - Tap entire card to select

2. **Sell** (outlined card, green border when hovered)
   - Store/shop icon (green)
   - "Sell" (bold)
   - "I want to sell a product or service" (description)
   - Tap entire card to select

**Behavior**:
- Selecting Buy → Navigate to Buy Transaction page
- Selecting Sell → Navigate to Sell Transaction page

---

### Buy Transaction Page (`buy_transaction.png`)
**File Reference**: `buy_transaction.png`

**Header** (navy blue):
- Back arrow
- "Buy Transaction" title
- "You're purchasing something" subtitle

**Form** (white background):

1. **What are you buying?**
   - Text input
   - Placeholder: "e.g., iPhone 15 Pro"

2. **Category**
   - Dropdown select
   - Default: "Physical Product"
   - Options: Physical Product, Digital Product, Service

3. **Seller Username/Phone**
   - Text input
   - Placeholder: "@username or +1234567890"
   - Helper: "Enter the username or phone number of the seller"

4. **Amount (USD)**
   - Currency input
   - Placeholder: "0.00"
   - Dollar sign prefix
   - Helper: "This amount will be held in escrow until you confirm receipt"

5. **Description**
   - Textarea (4-5 rows)
   - Placeholder: "Describe what you're purchasing..."

**Create Escrow Transaction** button (navy blue, full width, bottom)
- Disabled (gray) until all required fields filled

---

## ✅ CONFIRMATION MODALS

### Confirm Transaction Modal - Create Escrow (`confirm_transaction.png`)
**File Reference**: `confirm_transaction.png`

**Modal Overlay**:
- Dark semi-transparent background
- Centered white card

**Header** (navy blue bar):
- Lock icon (white)
- "Confirm Transaction" title
- "Enter your PIN to continue" subtitle
- Close X button (top right)

**Content** (white):
- "Action" label (gray)
- "Create Escrow Transaction" (bold)
- "Amount" label
- **$355** (large, bold)
- "Transaction ID" label
- "ESC-85205" (gray)
- **PIN Input**: "Enter 4-Digit PIN" label
  - 4 circular input dots (masked)
  - Or PIN pad (hidden initially)
- Demo text: "For demo purposes, use PIN: 1234" (small, gray)

**Buttons**:
- **Confirm** button (light blue, full width)
- **Cancel** button (white/gray outline, full width)

---

### Confirm Transaction Modal - Release Funds (`confirm_transaction_release_funds.png`)
**File Reference**: `confirm_transaction_release_funds.png`

Same layout as above but:
- "Action": "Release Funds"
- "Amount": **$850.00**
- "Transaction ID": "ESC-45823"

---

### Confirm Transaction Modal - Confirm Action (`confirm_transaction_confirm_action.png`)
**File Reference**: `confirm_transaction_confirm_action.png`

Same layout but:
- "Action": "Confirm Action"
- "Amount": **$889**
- No Transaction ID shown (payment confirmation)

---

## ✅ SUCCESS/CONFIRMATION PAGES

### Transaction Successful Page (`transaction_successful.png`)
**File Reference**: `transaction_successful.png`

**Full Screen** (light gray/white background):
- Large **green checkmark icon** with circular background and glow effect (centered, top 30%)
- **"Transaction Successful"** (large heading, centered)
- "Your transaction has been completed successfully." (gray text, centered)

**Transaction Summary Card** (white, centered):
- "Transaction ID": "ESC-10234"
- "Amount": **$889** (large, bold)
- "Status": **"Completed"** badge (green pill)
- "Date": "Oct 30, 2025, 12:59 PM"

**Action Buttons**:
- **🏠 Back to Dashboard** button (navy blue, full width)
- Row of 2 buttons:
  - **⬇ Download** (outlined)
  - **↗ Share** (outlined)

---

### Withdrawal Successful Page (`withdrawal_success.png`)
**File Reference**: `withdrawal_success.png`

Same layout as Transaction Successful but:
- Title: **"Withdrawal Successful"**
- Description: "Your withdrawal request has been processed successfully."
- Transaction ID: "ESC-10234"
- Amount: **$334**
- Status: **"Completed"** (green)
- Date: "Oct 30, 2025, 01:00 PM"

---

### Escrow Created Successfully Pages (`create_escrow_success.png`)
**File Reference**: `create_escrow_success.png`

Same layout but:
- Title: **"Escrow Created Successfully"**
- Description: "Your escrow transaction has been created successfully. Funds are now held securely until delivery confirmation."
- Transaction ID: "ESC-85205" or "ESC-98637"
- Amount: **$355** or **$244**
- Status: **"In Escrow"** badge (blue pill)
- Date: "Oct 30, 2025, 12:57 PM"

**Additional Element**:
- **View Transaction Details** button (navy outline, full width)
- Then Download and Share buttons

**Toast Notification** (bottom):
- "Notifications sent to both parties" with checkmark
- Green background, white text

---

## 🔧 TECHNICAL REQUIREMENTS

### Framework & Libraries
```json
{
  "framework": "React Native (Expo) or Next.js with responsive mobile design",
  "stateManagement": "React Context API or Redux Toolkit",
  "routing": "React Navigation (RN) or Next.js App Router",
  "styling": "Styled Components or Tailwind CSS",
  "forms": "React Hook Form",
  "validation": "Zod or Yup",
  "icons": "Lucide React or React Native Vector Icons",
  "animations": "Framer Motion (web) or React Native Reanimated"
}
```

### Component Structure
```
src/
├── components/
│   ├── common/
│   │   ├── Button.jsx
│   │   ├── Input.jsx
│   │   ├── Card.jsx
│   │   ├── Badge.jsx
│   │   ├── Modal.jsx
│   │   ├── Toast.jsx
│   │   └── BottomNav.jsx
│   ├── auth/
│   │   ├── LoginForm.jsx
│   │   ├── SignUpForm.jsx
│   │   ├── OTPModal.jsx
│   │   └── ForgotPasswordForm.jsx
│   ├── dashboard/
│   │   ├── BalanceCards.jsx
│   │   ├── StatsCard.jsx
│   │   ├── TransactionCard.jsx
│   │   └── FilterTabs.jsx
│   ├── transaction/
│   │   ├── TransactionDetails.jsx
│   │   ├── ProgressTracker.jsx
│   │   ├── ParticipantsCard.jsx
│   │   └── ActivityLog.jsx
│   ├── wallet/
│   │   ├── WalletCard.jsx
│   │   ├── TransactionHistory.jsx
│   │   └── PaymentMethodSelector.jsx
│   └── profile/
│       ├── ProfileCard.jsx
│       ├── EditProfileForm.jsx
│       └── SettingsList.jsx
├── pages/
│   ├── auth/
│   ├── onboarding/
│   ├── dashboard/
│   ├── deals/
│   ├── transaction/
│   ├── wallet/
│   ├── settings/
│   └── profile/
├── hooks/
│   ├── useAuth.js
│   ├── useTransaction.js
│   ├── useWallet.js
│   └── useNotifications.js
├── context/
│   ├── AuthContext.jsx
│   ├── TransactionContext.jsx
│   └── ThemeContext.jsx
├── services/
│   ├── api.js
│   ├── auth.js
│   ├── transactions.js
│   └── wallet.js
├── utils/
│   ├── formatters.js
│   ├── validators.js
│   └── constants.js
└── styles/
    ├── theme.js
    ├── colors.js
    └── typography.js
```

---

## 🎯 PIXEL-PERFECT IMPLEMENTATION CHECKLIST

### Must Match Exactly:
- ✅ All colors (hex codes extracted from images)
- ✅ All font sizes and weights
- ✅ All spacing (margins, paddings)
- ✅ All border radius values
- ✅ All icon sizes and styles
- ✅ All button heights and widths
- ✅ All card shadows and elevations
- ✅ All badge styles and colors
- ✅ All input field styles
- ✅ All modal dimensions and positioning
- ✅ All navigation bar styling
- ✅ All status colors (green, blue, orange, red)
- ✅ All animations and transitions
- ✅ All loading states
- ✅ All error states
- ✅ All empty states

### Responsive Behavior:
- Mobile-first design (320px - 428px width)
- Tablet support (768px - 1024px)
- Desktop optional (1280px+)

### Accessibility:
- WCAG AA color contrast
- Touch target minimum 44x44px
- Screen reader support
- Keyboard navigation

### Performance:
- Lazy loading for images
- Code splitting for routes
- Optimized animations (60fps)
- Fast initial load (<3s)

---

## 📝 FUNCTIONAL REQUIREMENTS

### Authentication
- Email/password login with validation
- OTP verification (mock or real)
- Social login (optional)
- Remember me functionality
- Forgot password flow
- Session management
- Auto-logout after inactivity

### Dashboard
- Real-time balance updates
- Transaction filtering
- Search functionality
- Pull-to-refresh
- Infinite scroll for transaction list

### Transactions
- Create buy/sell transactions
- Escrow creation
- Fund release mechanism
- Dispute raising
- Transaction status tracking
- Progress visualization
- Activity timeline

### Wallet
- View balance (available + escrow)
- Top up wallet
- Withdraw funds
- Transaction history
- Payment method management

### Messaging
- Real-time chat (WebSocket or polling)
- Message notifications
- Online/offline status
- Typing indicators
- Message timestamps

### Notifications
- Push notifications (Firebase/OneSignal)
- In-app notifications
- Email alerts
- Notification preferences
- Mark as read/unread
- Filter and search

### Profile & Settings
- Edit profile information
- Upload profile picture
- Change password
- Enable 2FA
- Biometric login
- Language/currency preferences
- Dark mode toggle

---

## 🚀 IMPLEMENTATION STEPS

### Phase 1: Setup & Design System (Week 1)
1. Initialize project with chosen framework
2. Set up folder structure
3. Create theme configuration (colors, typography, spacing)
4. Build reusable components (Button, Input, Card, Badge, Modal)
5. Implement bottom navigation
6. Set up routing

### Phase 2: Authentication (Week 1-2)
1. Login page with validation
2. Sign up page with validation
3. OTP modal
4. Forgot password flow
5. Auth context and state management
6. Protected routes

### Phase 3: Onboarding (Week 2)
1. Three onboarding screens
2. Swipe navigation
3. Skip functionality
4. Pagination dots

### Phase 4: Dashboard & Deals (Week 2-3)
1. Dashboard layout
2. Balance cards
3. Stats card
4. Transaction list
5. Filter functionality
6. Deals page
7. Search functionality

### Phase 5: Transactions (Week 3-4)
1. Transaction details page
2. Progress tracker
3. Activity log
4. Create transaction flows
5. Confirmation modals
6. Success pages

### Phase 6: Wallet (Week 4)
1. Wallet page
2. Transaction history
3. Fund wallet flow
4. Withdrawal flow
5. Payment method selection

### Phase 7: Profile & Settings (Week 4-5)
1. Profile page
2. Edit profile
3. Settings page
4. Dark mode implementation
5. Preferences management

### Phase 8: Messaging & Notifications (Week 5)
1. Chat interface
2. Message list
3. Notifications page
4. Push notifications setup

### Phase 9: Polish & Testing (Week 6)
1. Animations and transitions
2. Loading states
3. Error handling
4. Empty states
5. Responsive testing
6. Cross-browser testing
7. Performance optimization

---

## 🎨 DESIGN TOKENS

```javascript
// theme.js
export const theme = {
  colors: {
    primary: {
      main: '#0A2647',
      light: '#144272',
      lighter: '#205295',
      muted: '#7B96B0',
    },
    success: {
      main: '#00C853',
      light: '#69F0AE',
      bg: '#E8F5E9',
    },
    warning: {
      main: '#FF9800',
      light: '#FFB74D',
      bg: '#FFF3E0',
    },
    error: {
      main: '#E53935',
      light: '#EF5350',
      bg: '#FFEBEE',
    },
    info: {
      main: '#2196F3',
      light: '#64B5F6',
      bg: '#E3F2FD',
    },
    neutral: {
      white: '#FFFFFF',
      bg: '#F5F7FA',
      border: '#E0E0E0',
      text: '#1A1A1A',
      textSecondary: '#666666',
      textTertiary: '#999999',
    },
  },
  typography: {
    fontFamily: "'Inter', 'SF Pro Display', 'Roboto', sans-serif",
    fontSize: {
      xs: '10px',
      sm: '12px',
      base: '14px',
      md: '15px',
      lg: '16px',
      xl: '18px',
      '2xl': '20px',
      '3xl': '24px',
      '4xl': '28px',
    },
    fontWeight: {
      regular: 400,
      medium: 500,
      semibold: 600,
      bold: 700,
    },
    lineHeight: {
      tight: 1.2,
      normal: 1.5,
      relaxed: 1.75,
    },
  },
  spacing: {
    xs: '4px',
    sm: '8px',
    md: '12px',
    lg: '16px',
    xl: '20px',
    '2xl': '24px',
    '3xl': '32px',
    '4xl': '40px',
  },
  borderRadius: {
    sm: '6px',
    md: '8px',
    lg: '12px',
    xl: '16px',
    '2xl': '20px',
    full: '9999px',
  },
  shadows: {
    sm: '0 1px 2px rgba(0, 0, 0, 0.05)',
    md: '0 4px 6px rgba(0, 0, 0, 0.07)',
    lg: '0 10px 15px rgba(0, 0, 0, 0.1)',
    xl: '0 20px 25px rgba(0, 0, 0, 0.15)',
  },
  transitions: {
    fast: '150ms ease-in-out',
    normal: '250ms ease-in-out',
    slow: '350ms ease-in-out',
  },
};
```

---

## 🔍 QUALITY ASSURANCE

### Visual Testing
- Compare each screen side-by-side with original screenshots
- Verify all colors match exactly
- Check all spacing is consistent
- Ensure typography matches precisely

### Functional Testing
- Test all user flows end-to-end
- Verify form validations
- Test error states
- Verify success states
- Test navigation flows

### Cross-Platform Testing
- iOS Safari
- Android Chrome
- Desktop browsers (if responsive)

### Performance Testing
- Lighthouse score >90
- First Contentful Paint <1.5s
- Time to Interactive <3s

---

## 📦 DELIVERABLES

1. **Complete Source Code**
   - All components
   - All pages
   - All assets
   - Configuration files

2. **Documentation**
   - Setup instructions
   - Component documentation
   - API integration guide
   - Deployment guide

3. **Design System**
   - Color palette
   - Typography scale
   - Component library
   - Icon set

4. **Demo**
   - Working prototype
   - Test credentials
   - Sample data

---

## 🎯 SUCCESS CRITERIA

The implementation will be considered successful when:

1. **Visual Accuracy**: All screens match the original screenshots at 95%+ accuracy
2. **Functionality**: All user flows work as expected without errors
3. **Responsiveness**: Works perfectly on mobile devices (320px - 428px width)
4. **Performance**: Loads quickly and runs smoothly (60fps animations)
5. **Code Quality**: Clean, maintainable, well-documented code
6. **Accessibility**: Meets WCAG AA standards
7. **Testing**: All major user flows tested and working

---

## 🚨 CRITICAL NOTES

1. **DO NOT improvise or add features not shown in screenshots**
2. **DO NOT change colors, fonts, or spacing without matching screenshots exactly**
3. **DO NOT skip any screens or functionality shown in images**
4. **DO reference the original screenshots constantly during development**
5. **DO ask for clarification if any detail is unclear**
6. **DO prioritize pixel-perfect implementation over quick delivery**

---

## 📸 REFERENCE IMAGES

All 35 screenshots are available in `/mnt/project/` directory:

**Authentication & Onboarding:**
- login.png
- login_otp_popup.png
- sign_up.png
- forgot_password.png
- onboarding_1.png, onboarding_2.png, onboarding_3.png

**Dashboard & Navigation:**
- dashboard.png
- dashboard_filter.png
- deals.png

**Transactions:**
- buy_transaction.png
- transaction_details.png, transaction_details_2.png, transaction_details_3.png
- confirm_transaction.png
- confirm_transaction_confirm_action.png
- confirm_transaction_release_funds.png
- confirmation_transaction.png
- create_transaction_button.png

**Success Pages:**
- create_escrow_success.png
- transaction_successful.png
- successful_transaction.png
- withdrawal_success.png

**Wallet:**
- top_up.png
- fund_wallet.png, fund_wallet_2.png
- withdraw_funds.png

**Profile & Settings:**
- profile.png
- edit_profile.png, edit_profile_2.png
- settings.png, setting_2.png
- dark_mode_eneabled.png

**Communication:**
- message_chat.png
- notification.png

---

**END OF COMPREHENSIVE PROMPT**

Use this prompt to build a pixel-perfect, fully functional escrow transaction application that matches every detail shown in the provided screenshots.
