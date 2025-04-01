# Data Model Design

## Overview

The data model for Cashly is designed to support a conversation-centric financial platform, with models organized around user information, financial data, and conversation history. The schema prioritizes efficient access patterns for conversation context while maintaining data integrity for financial records.

## Core Model Relationships

```
┌─────────────┐     ┌─────────────────┐     ┌────────────────┐
│             │     │                 │     │                │
│    User     │─────│ FinConversation │─────│   FinMessage   │
│             │     │                 │     │                │
└─────────────┘     └─────────────────┘     └────────────────┘
       │                                            │
       │                                            │
       │      ┌─────────────┐    ┌──────────────┐  │
       │      │             │    │              │  │
       └──────│   Account   │────│ Transaction  │──┘
              │             │    │              │
              └─────────────┘    └──────────────┘
                     │                  │
                     │                  │
              ┌─────────────┐    ┌──────────────┐
              │             │    │              │
              │   Budget    │    │   Category   │
              │             │    │              │
              └─────────────┘    └──────────────┘
```

## User Authentication Models

### User
```ruby
class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :trackable, :omniauthable
         
  # Associations
  has_many :fin_conversations, dependent: :destroy
  has_many :accounts, dependent: :destroy
  has_many :transactions, through: :accounts
  has_many :budgets, dependent: :destroy
  
  # User preferences
  has_one :user_preference, dependent: :destroy
  
  # Profile information
  has_one :profile, dependent: :destroy
end
```

**Database Columns:**
- `id`: bigint, primary key
- `email`: string, unique, indexed
- `encrypted_password`: string
- `reset_password_token`: string, indexed
- `reset_password_sent_at`: datetime
- `remember_created_at`: datetime
- `sign_in_count`: integer, default: 0
- `current_sign_in_at`: datetime
- `last_sign_in_at`: datetime
- `current_sign_in_ip`: string
- `last_sign_in_ip`: string
- `confirmation_token`: string, indexed
- `confirmed_at`: datetime
- `confirmation_sent_at`: datetime
- `unconfirmed_email`: string
- `failed_attempts`: integer, default: 0
- `unlock_token`: string, indexed
- `locked_at`: datetime
- `created_at`: datetime
- `updated_at`: datetime

### UserPreference
```ruby
class UserPreference < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :currency, presence: true
  validates :language, presence: true
  validates :timezone, presence: true
end
```

**Database Columns:**
- `id`: bigint, primary key
- `user_id`: bigint, foreign key, indexed
- `currency`: string, default: 'USD'
- `language`: string, default: 'en'
- `timezone`: string, default: 'UTC'
- `notification_preferences`: jsonb
- `privacy_settings`: jsonb
- `ui_preferences`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

### Profile
```ruby
class Profile < ApplicationRecord
  # Associations
  belongs_to :user
  
  # Validations
  validates :first_name, presence: true
  validates :last_name, presence: true
end
```

**Database Columns:**
- `id`: bigint, primary key
- `user_id`: bigint, foreign key, indexed
- `first_name`: string
- `last_name`: string
- `display_name`: string
- `bio`: text
- `avatar_url`: string
- `phone_number`: string
- `address`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

## Conversation Models

### FinConversation
```ruby
class FinConversation < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :fin_messages, dependent: :destroy
  
  # Scopes
  scope :recent, -> { order(updated_at: :desc) }
  
  # Methods
  def add_message(content, role)
    fin_messages.create(content: content, role: role)
  end
  
  def context_summary
    # Generate a summary of the conversation context
  end
end
```

**Database Columns:**
- `id`: bigint, primary key
- `user_id`: bigint, foreign key, indexed
- `title`: string
- `status`: string, default: 'active'
- `context`: jsonb
- `metadata`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

### FinMessage
```ruby
class FinMessage < ApplicationRecord
  # Associations
  belongs_to :fin_conversation, touch: true
  has_many :fin_message_references
  has_many :referenced_entities, through: :fin_message_references
  
  # Validations
  validates :content, presence: true
  validates :role, presence: true, inclusion: { in: ['user', 'assistant', 'system'] }
  
  # Scopes
  scope :chronological, -> { order(created_at: :asc) }
  scope :user_messages, -> { where(role: 'user') }
  scope :assistant_messages, -> { where(role: 'assistant') }
end
```

**Database Columns:**
- `id`: bigint, primary key
- `fin_conversation_id`: bigint, foreign key, indexed
- `content`: text
- `role`: string
- `metadata`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

### FinMessageReference
```ruby
class FinMessageReference < ApplicationRecord
  # Associations
  belongs_to :fin_message
  belongs_to :referenced_entity, polymorphic: true
  
  # Validations
  validates :reference_type, presence: true
end
```

**Database Columns:**
- `id`: bigint, primary key
- `fin_message_id`: bigint, foreign key, indexed
- `referenced_entity_type`: string
- `referenced_entity_id`: bigint
- `reference_type`: string
- `metadata`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

## Financial Models

### Account
```ruby
class Account < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :transactions, dependent: :destroy
  
  # Validations
  validates :name, presence: true
  validates :account_type, presence: true
  validates :balance, presence: true
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_type, ->(type) { where(account_type: type) }
  
  # Methods
  def update_balance!
    # Calculate and update the current balance
  end
end
```

**Database Columns:**
- `id`: bigint, primary key
- `user_id`: bigint, foreign key, indexed
- `name`: string
- `account_type`: string
- `institution`: string
- `account_number_last_four`: string
- `balance`: decimal, precision: 10, scale: 2
- `available_balance`: decimal, precision: 10, scale: 2
- `currency`: string, default: 'USD'
- `status`: string, default: 'active'
- `external_id`: string
- `metadata`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

### Transaction
```ruby
class Transaction < ApplicationRecord
  # Associations
  belongs_to :account
  belongs_to :category, optional: true
  has_many :fin_message_references, as: :referenced_entity
  
  # Validations
  validates :amount, presence: true
  validates :transaction_date, presence: true
  
  # Scopes
  scope :recent, -> { order(transaction_date: :desc) }
  scope :income, -> { where('amount > 0') }
  scope :expense, -> { where('amount < 0') }
  scope :by_date_range, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }
  
  # Callbacks
  after_save :update_account_balance
  
  # Methods
  def update_account_balance
    account.update_balance!
  end
end
```

**Database Columns:**
- `id`: bigint, primary key
- `account_id`: bigint, foreign key, indexed
- `category_id`: bigint, foreign key, indexed, nullable
- `amount`: decimal, precision: 10, scale: 2
- `description`: string
- `merchant_name`: string
- `transaction_date`: date, indexed
- `posted_date`: date
- `status`: string, default: 'posted'
- `transaction_type`: string
- `is_recurring`: boolean, default: false
- `external_id`: string
- `metadata`: jsonb
- `created_at`: datetime
- `updated_at`: datetime

### Category
```ruby
class Category < ApplicationRecord
  # Associations
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
  has_many :transactions
  has_many :budgets
  
  # Validations
  validates :name, presence: true, uniqueness: { scope: :parent_id }
  
  # Scopes
  scope :top_level, -> { where(parent_id: nil) }
  scope :by_type, ->(type) { where(category_type: type) }
  
  # Methods
  def all_transactions
    # Get all transactions, including those in subcategories
  end
end
```

**Database Columns:**
- `id`: bigint, primary key
- `parent_id`: bigint, foreign key, indexed, nullable
- `name`: string
- `description`: text
- `category_type`: string
- `icon`: string
- `color`: string
- `is_system`: boolean, default: false
- `created_at`: datetime
- `updated_at`: datetime

### Budget
```ruby
class Budget < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :category, optional: true
  
  # Validations
  validates :name, presence: true
  validates :amount, presence: true
  validates :period, presence: true
  
  # Scopes
  scope :active, -> { where(status: 'active') }
  scope :by_period, ->(period) { where(period: period) }
  
  # Methods
  def current_spending
    # Calculate current spending for this budget period
  end
  
  def remaining_amount
    # Calculate remaining budget amount
  end
  
  def percentage_used
    # Calculate percentage of budget used
  end
end
```

**Database Columns:**
- `id`: bigint, primary key
- `user_id`: bigint, foreign key, indexed
- `category_id`: bigint, foreign key, indexed, nullable
- `name`: string
- `amount`: decimal, precision: 10, scale: 2
- `period`: string # 'monthly', 'quarterly', 'annual'
- `start_date`: date
- `end_date`: date, nullable
- `status`: string, default: 'active'
- `rollover_enabled`: boolean, default: false
- `created_at`: datetime
- `updated_at`: datetime

## Database Migrations

Here are the key migration files we'll need to create these models:

### User Authentication
- `devise_create_users.rb`
- `create_user_preferences.rb`
- `create_profiles.rb`

### Conversation
- `create_fin_conversations.rb`
- `create_fin_messages.rb`
- `create_fin_message_references.rb`

### Financial
- `create_accounts.rb`
- `create_transactions.rb`
- `create_categories.rb`
- `create_budgets.rb`

## Indexing Strategy

To ensure optimal performance, we'll implement the following indexes:

### Conversation-Related Indexes
- `fin_conversations`: `user_id`, `status`
- `fin_messages`: `fin_conversation_id`, `role`, `created_at`
- `fin_message_references`: `fin_message_id`, `(referenced_entity_type, referenced_entity_id)`

### Financial Data Indexes
- `accounts`: `user_id`, `account_type`, `status`
- `transactions`: `account_id`, `category_id`, `transaction_date`, `status`
- `categories`: `parent_id`, `category_type`
- `budgets`: `user_id`, `category_id`, `period`, `status`

## Data Access Patterns

### Common Access Patterns
1. Retrieve user's recent conversations
2. Get complete conversation history with messages
3. Access user's accounts and balances
4. Query transactions by date range and category
5. Access budget information and spending status

### Performance Optimizations
1. Denormalize frequently accessed data
2. Use counter caches for counts (e.g., message counts)
3. Implement materialized views for complex aggregations
4. Use partial indexes for filtered queries

## Data Integrity and Constraints

### Foreign Key Constraints
- All relationships will use foreign key constraints to maintain referential integrity

### Unique Constraints
- Unique email addresses for users
- Unique conversation titles per user
- Unique category names within the same parent

### Check Constraints
- Valid values for status fields
- Non-negative amounts for budgets
- Valid date ranges (start_date <= end_date)

This data model design provides a solid foundation for building Cashly as a conversation-centric financial platform, with clear relationships between users, conversations, and financial data, and optimized for the access patterns required by a conversational interface.