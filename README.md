# Personal Banking and Latest Stock Price Application

This repository consists of two main components:
1. **Personal Banking System**: Handles user authentication, wallet management, and financial transactions.
2. **Latest Stock Price Fetching System**: Fetches and stores the latest stock prices from an external API.

---

## Personal Banking System

### Features

- **User Authentication**:
  - User login and logout functionality.
  - Session-based authentication.

- **Wallet Management**:
  - Show wallet balance.
  - Handle transactions between users.

### Setup
- **Clone the repository**

  ```sh
  git clone https://github.com/theyudiriski/personal-banking
  ```

- **Install dependencies:**

  ```sh
  bundle install
  ```
- **Database setup:**

  ```sh
  rails db:create
  rails db:migrate
  rails db:seed
  ```
- **Environment setup:**

  Create an `.env` file to store environment variables such as API keys or database configuration and add necessary values:

  ```sh
  PORT='3000'

  POSTGRES_HOST='localhost'
  POSTGRES_DB_NAME='personal_banking_db'
  POSTGRES_USERNAME='root'
  POSTGRES_PASSWORD=''

  POSTGRES_TEST_HOST='localhost'
  POSTGRES_TEST_DB_NAME='personal_banking_test_db'
  POSTGRES_TEST_USERNAME='root'
  POSTGRES_TEST_PASSWORD=''

  REDIS_HOST='127.0.0.1'
  REDIS_PORT='6379'
  ```
- **Running the App:**

  ```sh
  rails s
  ```
  Visit http://localhost:3000 to access the personal banking application.

---

## Latest Stock Price

### Features
- **Stock Price Fetching:**
  - Fetches stock prices from the RapidAPI stock price API.
  - Upserts stock price records in the database.

### Setup
Same setup as Personal Banking App. Make sure you already register RapidAPI Key in `.env` file:

```sh
# check docs file for api key

RAPIDAPI_KEY='xyz'
```

### Sidekiq Setup
Sidekiq is used for background job processing in this application. Follow these steps to set up and run Sidekiq:
- **Ensure Redis is running:**

  Sidekiq requires Redis to work. You can start Redis locally by running:

  ```sh
  redis-server
  ```
- **Start Sidekiq:**

  In a separate terminal window from your Rails server, run Sidekiq:

  ```sh
  bundle exec sidekiq
  ```
  This will start the background job processor that works with Redis.

- **Enqueuing Jobs:**

  Now, any background jobs will be processed by Sidekiq. For example, when fetching stock prices, a job can be enqueued to run in the background instead of being executed immediately.

### Running Rake Tasks
We can run the task manually using rake. Make sure Sidekiq already up and running.

- **Fetch and store latest stock prices:**

    Use the following rake task to fetch stock prices from the API and store them in the database:

    ```sh
    rake latest_stock_prices:fetch_and_store
    ```

---

### Testing
To run tests:

```sh
bundle exec rspec
```

You can see the test coverage in `/coverage/.last_run.json` file.

### Lint
To check and fix code style with Rubocop:

```sh
bundle exec rubocop -a
```
