# Vietnam National Hospital DBMS: Development Mode Enhancements

## Overview

To make the application more user-friendly and eliminate the requirement for Oracle client libraries during development, we've implemented a dual-database approach with automatic detection and fallback to SQLite.

## Key Changes

### 1. SQLite Development Mode
- Added a development mode that uses SQLite instead of Oracle
- Automatically creates and populates a sample SQLite database
- Can be activated by setting `DEV_MODE=true` or using `./run.sh` (now the default)

### 2. Database Models
- Created a robust SQLite schema in `models/sqlite_models.py`
- Implemented automatic sample data generation for development
- Schema closely matches the planned Oracle production schema

### 3. Database Connection System
- Enhanced `database.py` to detect environment and use the appropriate database
- Added robust error handling and logging
- Improved connection string management

### 4. Run Script Improvements
- Made development mode the default for easier onboarding
- Enhanced Oracle client detection to check multiple locations
- Improved error messages and user guidance
- Added graceful shutdown handling for servers

### 5. Environment Configuration
- Updated `.env.example` with clear documentation
- Added `DEV_MODE` flag to control database backend
- Separated development vs. production settings

### 6. Documentation
- Created comprehensive README files for the main project, backend, and frontend
- Added clear instructions for both development and production modes
- Documented API endpoints and troubleshooting steps

## Benefits

1. **No Oracle Dependency**: Developers can now start working without Oracle client libraries
2. **Quick Setup**: Single-command setup with `./run.sh`
3. **Sample Data**: Development mode includes pre-populated sample data
4. **Smooth Transition**: Same API works with both SQLite and Oracle
5. **Better Error Handling**: Clear messages when something goes wrong
6. **Improved Documentation**: Comprehensive instructions for all scenarios

## Future Improvements

1. **Oracle-Specific Models**: Implement dedicated models for Oracle production environment
2. **Migration System**: Add tools to migrate data between SQLite and Oracle
3. **Admin Interface**: Create interface for managing sample data in development mode 