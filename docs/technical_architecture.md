# Technical Architecture Design

## System Overview

Cashly is designed as a modern, conversation-centric financial platform built on Ruby on Rails 8 with Hotwire (Turbo and Stimulus) for creating responsive, dynamic interfaces. The system architecture prioritizes the conversational experience while maintaining high performance, security, and scalability.

## Architecture Diagram

```
┌─────────────────────────┐      ┌─────────────────────────┐
│                         │      │                         │
│  Rails 8 Application    │      │  AI Service (Python)    │
│                         │      │                         │
│  ┌─────────────────┐    │      │  ┌─────────────────┐    │
│  │ Hotwire Front   │    │      │  │ Flask API       │    │
│  │ (Turbo+Stimulus)│    │      │  │                 │    │
│  └─────────────────┘    │      │  └─────────────────┘    │
│           │             │      │           │             │
│  ┌─────────────────┐    │      │  ┌─────────────────┐    │
│  │ Rails           │    │      │  │ Prompt          │    │
│  │ Controllers/API │────┼──────┼──│ Engineering     │    │
│  └─────────────────┘    │      │  └─────────────────┘    │
│           │             │      │           │             │
│  ┌─────────────────┐    │      │  ┌─────────────────┐    │
│  │ Domain Services │    │      │  │ Claude/GPT-4    │    │
│  │ (Finance/Fin)   │    │      │  │ Integrations    │    │
│  └─────────────────┘    │      │  └─────────────────┘    │
│           │             │      │                         │
│  ┌─────────────────┐    │      └─────────────────────────┘
│  │ Data Models     │    │                │
│  │                 │    │                │
│  └─────────────────┘    │                │
│           │             │                │
│  ┌─────────────────┐    │      ┌─────────────────────────┐
│  │ PostgreSQL      │    │      │                         │
│  │ Database        │    │      │  External Services      │
│  └─────────────────┘    │      │  (Plaid, etc.)          │
│                         │      │                         │
└─────────────────────────┘      └─────────────────────────┘
```

## Core Components

### 1. Rails 8 Backend

#### API-First Approach
- RESTful API endpoints for all financial data operations
- JSON API serialization for consistent data formatting
- API versioning strategy to support future changes
- Authentication using JWT for secure API access

#### Controller Structure
- Namespaced controllers for API endpoints (`Api::V1::`)
- Separate controllers for web interface and API
- Conversations controllers to manage Fin interactions
- Financial data controllers for accounts, transactions, etc.

#### Domain Services
- Conversation service for managing Fin interactions
- Financial analysis services for processing transaction data
- Data transformation services for preparing API responses
- Notification services for alerts and reminders

### 2. Hotwire Frontend

#### Turbo Drive and Frames
- Turbo Drive for full-page navigation without full reloads
- Turbo Frames for partial page updates, especially for conversation history
- Turbo Streams for real-time updates to conversations and financial data

#### Stimulus Controllers
- Conversation controller for managing chat interface
- Financial visualization controllers for charts and graphs
- Form controllers for in-conversation input handling
- Navigation controllers for app-wide navigation patterns

#### View Components
- Reusable conversation message components
- Financial card components for data display
- Visualization components for charts and graphs
- Navigation and layout components

### 3. Separate AI Service (Python/Flask)

#### API Interface
- RESTful API endpoints for conversation processing
- Authentication mechanism for secure communication
- Health check and monitoring endpoints
- Fallback mechanisms for service interruptions

#### LLM Integration
- Claude API integration as primary LLM
- GPT-4 integration as fallback option
- Caching strategy for common financial queries
- Monitoring and evaluation of response quality

#### Prompt Engineering Framework
- Financial domain-specific prompt templates
- Context management for conversation history
- Entity extraction and verification
- Response formatting guidelines

### 4. Database Design

#### Schema Organization
- Database schema optimized for financial conversation history
- Efficient indexing strategy for quick retrieval
- Partition strategy for large datasets
- Caching layer for frequently accessed data

#### Data Security
- Encryption for sensitive financial data
- Access control at the database level
- Audit logging for all data modifications
- Backup and recovery strategy

## Integration Points

### 1. Rails to AI Service Integration
- RESTful API calls between Rails and Flask
- Authentication using API keys
- Circuit breaker pattern for handling service unavailability
- Response caching for performance optimization

### 2. External Financial Services
- Plaid integration for bank account connections
- Payment processor integrations
- Financial data provider connections
- OAuth flows for secure authorization

### 3. Front-end to Back-end Integration
- Turbo Stream broadcasts for real-time updates
- Action Cable for WebSocket connections
- API endpoints for data operations
- Caching strategy for UI performance

## Deployment Architecture

### Production Environment
- Containerized deployment using Docker
- Kubernetes orchestration for scaling
- Separate deployments for Rails and AI services
- Database deployment with replication for high availability

### Scaling Strategy
- Horizontal scaling for web and API servers
- Vertical scaling for database instances
- Caching layer for reducing database load
- Load balancing for distributing traffic

### Monitoring and Observability
- Application performance monitoring
- Error tracking and reporting
- User experience monitoring
- System health dashboards

## Security Architecture

### Authentication and Authorization
- Devise for user authentication
- Role-based access control
- JWT tokens for API authorization
- OAuth integration for social login

### Data Protection
- Encryption at rest for sensitive data
- Encryption in transit (TLS/SSL)
- PCI compliance for financial data
- Regular security audits and penetration testing

### Compliance
- GDPR compliance for user data
- Financial regulations compliance
- Data retention policies
- User consent management

This technical architecture provides a solid foundation for building Cashly as a conversation-centric financial platform, with a clean separation of concerns and a focus on performance, security, and scalability.