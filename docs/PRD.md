# Product Requirements Document (PRD)

## 1. Product Overview

### 1.1 Product Name

Malaysia Cultural Tourism App (Working Title)

### 1.2 Purpose

The purpose of this application is to enhance tourism in Malaysia by providing a one-stop mobile platform for discovering, planning, and booking cultural destinations. The app enables tourists to browse verified cultural sites, view detailed information, and purchase tickets seamlessly, while allowing authorized admins to manage destination listings.

### 1.3 Goals & Objectives

* Promote Malaysian cultural tourism through a centralized digital platform
* Simplify booking and ticket purchasing for tourists
* Provide accurate, up-to-date cultural destination information
* Enable admins to efficiently manage destination data
* Improve user engagement through personalized recommendations

### 1.4 Success Metrics

* Number of registered users
* Number of bookings completed
* Conversion rate from browse to purchase
* Admin content update frequency
* User satisfaction ratings and reviews

---

## 2. Target Users

### 2.1 End Users (Tourists)

* Local and international tourists
* Users looking for cultural, historical, and heritage destinations
* Mobile-first users who prefer digital ticketing and planning

### 2.2 Admin Users

* Platform administrators
* Authorized representatives of cultural destinations
* Content managers responsible for data accuracy

---

## 3. User Requirements & Features

### 3.1 User Authentication

#### 3.1.1 Login

* Users shall be able to log in using email and password
* Users without an account shall be able to register
* Successful login redirects users to the main discover page

#### 3.1.2 Registration

* Users shall create an account using basic personal details
* System validates credentials before account creation

---

### 3.2 Browse & Discover

* System shall display a Discover page as the main screen
* Personalized recommendations based on:

  * User location (if permission granted)
  * Previous visits or searches
  * Budget preferences
* Search functionality to find specific destinations
* Category-based browsing (Events, Sites, Packages, Food)

---

### 3.3 Destination Information

* Users shall view a detailed attraction info page
* The page shall include:

  * Real images of the destination
  * Description and cultural significance
  * Operating hours
  * Distance from user
  * Ticket pricing (Adult, Child, Foreigner)
  * Address with Google Maps and Waze links
  * User reviews with timestamps

---

### 3.4 Booking & Ticketing

#### 3.4.1 Input Data

* Users shall input:

  * Ticket type (Adult / Child / Foreigner)
  * Quantity per ticket type
  * Visitor names
  * Visit date
* Inputs shall use dropdowns, date pickers, and text fields

#### 3.4.2 Price Calculation

* System calculates total price by:

  * Multiplying ticket price by quantity
  * Adding applicable taxes or extra charges

#### 3.4.3 Price Display

* System displays the final price clearly
* Final price must include all taxes and fees

---

### 3.5 Payment

* Users shall select a payment method:

  * Card payment
  * Online banking
* On payment failure:

  * Users are redirected to customer support communication

---

## 4. Admin Requirements & Features

### 4.1 Admin Authentication

* Admins shall log in using username and password
* Unauthorized users shall not access admin tools

---

### 4.2 Admin Dashboard

* Admin dashboard displays recent updates
* Each entry shows:

  * Site name
  * Action label (Add / Update)
  * Timestamp
* Admin can navigate to full site list

---

### 4.3 Site Management

#### 4.3.1 View Sites

* Admins shall view all cultural sites
* Each site displays:

  * Name
  * Category
  * Last updated timestamp

#### 4.3.2 Add New Site

* Admins shall add new destinations with:

  * Name
  * Description
  * Address
  * Images
  * Google Maps link
  * Waze link
  * Opening schedule (per day)
  * Ticket fees (Adult, Child, Foreigner)

#### 4.3.3 Update Site

* Admins shall edit existing site details
* Changes are saved via an Edit button

#### 4.3.4 Delete Site

* Admins shall remove outdated or incorrect listings

---

## 5. User Flow Overview

### 5.1 Tourist Booking Flow

1. User logs in
2. User browses or searches destinations
3. User views attraction details
4. User selects tickets and date
5. System calculates price
6. User completes payment

### 5.2 Admin Management Flow

1. Admin logs in
2. Admin views dashboard
3. Admin adds / updates / deletes site
4. Changes reflected to users

---

## 6. UI/UX Requirements

* Clean, mobile-first design
* Card-based layouts for readability
* Clear primary CTAs (Book Now, Pay, Add, Edit)
* Thumb-friendly buttons and selectors
* Consistent navigation (Top & Bottom Nav)

---

## 7. Non-Functional Requirements

### 7.1 Performance

* App should load key screens within 2–3 seconds

### 7.2 Security

* Secure authentication for users and admins
* Encrypted payment processing

### 7.3 Reliability

* High availability for booking and payment flows

### 7.4 Scalability

* System should support growing numbers of users and destinations

---

## 8. Assumptions & Constraints

* Internet connection required for full functionality
* Only verified admins can publish destinations
* Payment gateways depend on third-party services

---

## 9. Future Enhancements

* AI-driven recommendation engine
* In-app chat with destination owners
* Loyalty and reward system
* Multi-language support
* Offline ticket storage
