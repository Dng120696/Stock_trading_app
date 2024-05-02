# Stock Trading App

## Overview

- This trading application is designed to facilitate stock trading activities for both traders and administrators. It provides a platform for traders to buy and sell stocks, manage their portfolio, and monitor transactions. Administrators have access to features for managing traders, approving new sign-ups, and monitoring overall app activity.



## User Stories

### Traders
- **User Story #1:** As a Trader, I want to create an account to buy and sell stocks
- **User Story #2:** As a Trader, I want to log in my credentialls so that I can access my account on the app
- **User Story #3:** As a Trader, I want to receive an email to confirm my pending Account signup
- **User Story #4:** As a Trader, I want to receive an approval Trader Account email to notify me once my account has been approved
- **User Story #5:** As a Trader, I want to buy a stock to add to my investment(Trader signup should be approved)
- **User Story #6:** As a Trader, I want to have a My Portfolio Page to see all my stocks
- **User Story #7:** As a Trader, I want to have a Transaction page to see and monitor all the transactions made by buying and selling stocks
- **User Story #8:** As a Trader, I want to sell my stocks to gain money.

### Admin  
- **User Story #1:** As an Admin, I want to create a new trader to manualy add them to the app
- **User Story #2:** As an Admin, I want to edit a specific trader to update his/her details
- **User Story #3:** As an Admin, I want to view a specific trader to show his/her details
- **User Story #4:** As an Admin, I want to see all the trader that registered in the app so ican track all the traders
- **User Story #5:** As an Admin, I want to have a page for pending trader sign up to easily check if there's a new trader sign up
- **User Story #6:** As an Admin, I want to approve a trader sign up so that he/she can start adding stocks
- **User Story #7:** As an Admin, I want to see all the transactions so that I can monitor the transaction flow of the app


### Enhanced Features

- **Cash-In and Cash Out:** Traders can deposit funds into their trading account (cash-in) and withdraw funds from their trading account (cash-out). This feature allows traders to manage their liquidity for buying and selling stocks effectively.
- **Lazy Loading:** Lazy loading is implemented to improve the performance and user experience of the application. Instead of loading all the data at once, lazy loading loads data progressively as the user interacts with the application. This ensures faster initial page load times and smoother navigation throughout the application.
- **Profit/Loss Computation:** The application calculates and displays the profit or loss for each stock in the trader's portfolio. It considers the purchase price, current market price, and quantity of stocks owned by the trader. This feature helps traders assess the performance of their investments and make informed decisions.
- **OTP Confirmation(One-Time Password):** confirmation is used to enhance the security of trader accounts. When traders perform sensitive actions such as deposit or withdrawing funds, they receive a one-time password via email or SMS. They must enter this OTP to verify their identity and complete the action. This adds an extra layer of security and reduces the risk of unauthorized access to trader accounts.
- **Dark/Light Mode:** User preferences for interface appearance vary, and providing a choice between dark and light modes accommodates these preferences. Dark mode is not only aesthetically pleasing but also reduces eye strain, especially during prolonged usage, making it a sought-after feature by many users. By offering both modes, the application caters to a broader user base and enhances overall user satisfaction.


### **Trader App Views**

#### **News page**

![news_page][news_page_pic]

#### **Dashboard page**

![dashboard_page][dashboard_page_pic]

#### **Portfolio page**

![portfolio_page][portfolio_page_pic]

#### **Buy Stock page**

![buy_stock_page][buy_stock_page_pic]

#### **Sell Stock page**

![sell_stock_page][sell_stock_page_pic]

#### **Transaction History page**

![transaction_history][transaction_history_pic]

#### **Profile page**

![profile_page][profile_page_pic]

Check out the live demo of the app in the link below:

[Stock Trading App](https://mysite-jjbq.onrender.com)

## **Getting Started**

### **Prerequisites**

The setups steps expect the Builds listed above to be installed on the system

### **Instructions**

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

- Clone the repository and navigate to main app directory

```bash
git clone https://github.com/Dng120696/Stock_trading_app.git
cd stock_trading_app
```

- Install libraries and dependencies

```bash
bundle install
```

- Initialize the database

```bash
rails db:create
rails db:migrate
rails db:seed
```

- Run the server

```bash
./bin/dev
```

## **System dependencies**

### **Gems**

- Devise 4.8.1
- tailwindcss-rails 2.3
- iex-ruby-client
- chartkick
- groupdate

## Created by

**Development Team:**

- **Christian Patrick Nebab**
  - Email: [christianpatrickcnebab@gmail.com](mailto:christianpatrickcnebab@gmail.com)

- **Jeffrey Binas**

