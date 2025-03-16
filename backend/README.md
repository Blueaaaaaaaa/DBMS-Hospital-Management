# Vietnam National Hospital Dashboard Backend

This is the backend API for the Vietnam National Hospital Dashboard application. It provides a REST API for accessing hospital data, including facilities, departments, doctors, patients, medical records, and appointments.

## Features

- REST API for hospital data
- SQLite database for development
- Oracle database support for production
- Automatic database initialization with sample data

## Development Setup

The backend is designed to work out of the box in development mode with SQLite. This allows you to get started quickly without installing Oracle Database or client libraries.

### Prerequisites

- Python 3.8 or higher
- pip (Python package manager)
- virtualenv (recommended)

### Running in Development Mode

The easiest way to run the backend is to use the provided `run.sh` script from the root directory:

```bash
./run.sh --dev
```

This will:
1. Create a Python virtual environment if it doesn't exist
2. Install dependencies from `requirements.txt`
3. Configure the application to use SQLite
4. Start the backend server on port 5000

### Manual Setup

If you prefer to set up the backend manually:

1. Create and activate a virtual environment:
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```

3. Create a `.env` file:
   ```
   DEV_MODE=true
   ```

4. Run the application:
   ```bash
   python app.py
   ```

## Production Setup with Oracle

To use Oracle Database in production:

1. Install Oracle Instant Client libraries (see Oracle's documentation)
2. Set up Oracle Database (or use an existing one)
3. Create a `.env` file with Oracle connection details:
   ```
   DEV_MODE=false
   DB_USER=your_username
   DB_PASSWORD=your_password
   DB_HOST=your_host
   DB_PORT=1521
   DB_SERVICE=your_service_name
   ```

4. Run the application with the `--prod` flag:
   ```bash
   ./run.sh --prod
   ```

## API Documentation

The API provides the following endpoints:

- `GET /api/health` - Health check endpoint
- `GET /api/facilities` - Get all facilities
- `GET /api/facilities/:id` - Get facility by ID
- `GET /api/departments` - Get all departments
- `GET /api/departments/:id` - Get department by ID
- `GET /api/departments/:id/doctors` - Get doctors in a department
- `GET /api/departments/:id/staff` - Get staff in a department
- `GET /api/doctors` - Get all doctors
- `GET /api/doctors/:id` - Get doctor by ID
- `GET /api/patients` - Get all patients
- `GET /api/patients/:id` - Get patient by ID
- `GET /api/appointments` - Get all appointments
- `GET /api/appointments/:id` - Get appointment by ID
- `GET /api/records` - Get all medical records
- `GET /api/records/:id` - Get medical record by ID
- `GET /api/stats/departments` - Get department statistics
- `GET /api/stats/appointments` - Get appointment statistics
- `GET /api/stats/patients` - Get patient statistics

## Database Models

The application uses SQLAlchemy ORM to interact with the database. The data models are defined in:

- `models/sqlite_models.py` - For SQLite (development mode)

## Troubleshooting

- **Missing Oracle Client Libraries**: If you get an error about missing Oracle Client libraries when running in production mode, make sure you have installed Oracle Instant Client and set the `LD_LIBRARY_PATH` environment variable correctly.

- **Database Connection Issues**: Check your `.env` file for correct database credentials.

- **Import Errors**: Make sure you have installed all dependencies from `requirements.txt`.