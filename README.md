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

## **Live Demo**

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
