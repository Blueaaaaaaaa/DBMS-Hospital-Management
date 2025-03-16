# Vietnam National Hospital Distributed Database Management System

A comprehensive web-based visualization dashboard for Vietnam National Hospital's distributed database system.

## Project Overview

The Vietnam National Hospital DBMS is a full-stack application designed to provide visualization and management capabilities for the hospital's distributed database system. It allows hospital staff to monitor and manage facilities, departments, doctors, patients, appointments, and medical records across multiple hospital locations.

The system features a modern web dashboard that visualizes database replication, facility connections, and system health, while also providing interfaces for day-to-day hospital management tasks.

## Key Features

- **Dashboard with Real-time Metrics**: Key performance indicators and statistics for hospital operations
- **Facility Management**: View and manage multiple hospital facilities
- **Department Overview**: Department details and staffing information
- **Doctor Directory**: Comprehensive doctor profiles and specializations
- **Patient Management**: Patient records and medical history
- **Appointment Scheduling**: Appointment booking and tracking
- **Medical Records**: Secure patient medical record management
- **Distributed System Monitoring**: Visualization of database replication and system architecture

## Getting Started

### Prerequisites

- Python 3.8 or higher
- Node.js 14 or higher and npm
- For production: Oracle Database and Oracle Instant Client libraries

### Quick Start with Development Mode

We've simplified setup with a development mode that uses SQLite instead of Oracle, allowing you to get started quickly without Oracle Database or client libraries.

To use the development mode:

```bash
./run.sh
```

This will:
1. Set up Python virtual environment
2. Install backend dependencies
3. Configure SQLite database with sample data
4. Install frontend dependencies
5. Start both backend and frontend servers

### Production Setup

For production environments where you have Oracle Database:

```bash
./run.sh --prod
```

This requires Oracle Instant Client libraries to be installed on your system.

## Architecture

### Backend

- **Flask** - Python web framework for the RESTful API
- **SQLAlchemy** - ORM for database interactions
- **cx_Oracle** - Oracle database connectivity
- **SQLite** - Development database option

### Frontend

- **React** - JavaScript library for building the user interface
- **Material-UI** - Component library for modern UI design
- **Recharts** - Data visualization library
- **Axios** - HTTP client for API communication
- **React Router** - Navigation between components

## Database Configuration

The application supports two database options:

1. **SQLite** (Development): No setup required; automatically creates and populates database
2. **Oracle Database** (Production): Requires Oracle client libraries and credentials

Oracle database credentials are configured in the `.env` file in the backend directory:

```
DEV_MODE=false
DB_USER=your_username
DB_PASSWORD=your_password
DB_HOST=your_host
DB_PORT=1521
DB_SERVICE=your_service_name
```

## Distributed System Architecture

The dashboard visualizes the distributed database architecture of the Vietnam National Hospital system, showing:

- Central database node
- Regional facility database nodes
- Replication status between nodes
- Network metrics and connectivity

## Directory Structure

```
hospital_dashboard/
├── backend/                # Flask backend API
│   ├── models/             # Database models
│   ├── data/               # SQLite database files
│   ├── app.py              # Main application file
│   └── requirements.txt    # Python dependencies
├── frontend/               # React frontend
│   ├── public/             # Static files
│   ├── src/                # Source code
│   │   ├── components/     # Reusable components
│   │   ├── pages/          # Page components
│   │   └── services/       # API services
│   └── package.json        # Node.js dependencies
├── run.sh                  # Setup and run script
└── README.md               # This file
```

## Installation Options

### Automatic Setup (Recommended)

The provided `run.sh` script handles:
- Python virtual environment creation
- Dependency installation
- Database initialization
- Environment variable configuration
- Server startup

### Manual Setup

See the README files in the `backend/` and `frontend/` directories for step-by-step manual setup instructions.

## Troubleshooting

- **Missing Oracle Client Libraries**: In development mode, the system will use SQLite by default. For Oracle support, install Oracle Instant Client.
- **Database Connection Issues**: Check your database credentials in the .env file
- **Port Conflicts**: Make sure ports 3000 (frontend) and 5000 (backend) are available

## License

This project is licensed under the MIT License - see the LICENSE file for details. 