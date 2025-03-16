# Vietnam National Hospital Distributed Database Management System

A comprehensive visualization system for the Vietnam National Hospital database, highlighting the distributed database architecture and providing interactive dashboards for hospital administration.

## Project Overview

This project creates a web-based visualization dashboard for the Vietnam National Hospital's distributed database system. It connects to an Oracle SQL database and provides interactive visualizations of:

- Hospital facilities, departments, doctors, and patients
- Appointment scheduling and management
- Medical records tracking
- Distributed database replication and status monitoring

## Architecture

The system consists of two main components:

### Backend (Python/Flask)

- RESTful API endpoints for accessing hospital data
- Database connectivity to Oracle SQL
- Data processing and statistics calculation

### Frontend (React)

- Interactive dashboards with real-time data
- Modern UI with Material Design
- Visualizations using Recharts
- Distributed system visualization

## Features

- **Dashboard**: Key metrics and statistics about the hospital system
- **Facility Management**: Visualize and manage hospital facilities
- **Department Overview**: Staff and resource allocation by department
- **Doctor Directory**: Doctor information and schedules
- **Patient Management**: Patient records and appointment history
- **Appointment Scheduling**: Visual calendar for appointments
- **Distributed System Monitoring**: Real-time status of database replication and system health

## Getting Started

### Prerequisites

- Python 3.8+
- Node.js 14+
- Oracle Database

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd hospital_dashboard
   ```

2. Set up the backend:
   ```bash
   cd backend
   
   # Create and activate a virtual environment
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   
   # Install dependencies
   pip install -r requirements.txt
   
   # Configure the database connection
   cp .env.example .env
   # Edit .env with your Oracle database credentials
   ```

3. Set up the frontend:
   ```bash
   cd ../frontend
   
   # Install dependencies
   npm install
   ```

### Running the Application

1. Start the backend server:
   ```bash
   cd backend
   python app.py
   ```

2. Start the frontend development server:
   ```bash
   cd ../frontend
   npm start
   ```

3. Access the application at `http://localhost:3000`

## Deployment

### Backend Deployment

The backend can be deployed using Gunicorn and Nginx:

```bash
gunicorn --bind 0.0.0.0:5000 app:app
```

### Frontend Deployment

Build the React application for production:

```bash
cd frontend
npm run build
```

The build files can be served with any static file server or integrated with the backend.

## Database Configuration

The application connects to an Oracle SQL database. You'll need to set the following environment variables:

- `DB_USER`: Database username
- `DB_PASSWORD`: Database password
- `DB_HOST`: Database host/IP
- `DB_PORT`: Database port (usually 1521)
- `DB_SERVICE`: Oracle service name

## Distributed System Architecture

The hospital management system operates on a distributed database architecture:

- Each hospital facility has its own database instance
- Data is replicated between facilities for redundancy and high availability
- Central database serves as the main coordination point
- Automated failover ensures continuous service

The Distributed System visualization page shows real-time status of database nodes and network connectivity between facilities.

## License

This project is licensed under the MIT License - see the LICENSE file for details. 