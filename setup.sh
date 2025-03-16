#!/bin/bash

# Function to handle errors
handle_error() {
  echo "======================================"
  echo "ERROR: $1"
  echo "======================================"
  echo ""
  echo "Troubleshooting suggestions:"
  echo "1. For Python dependency issues:"
  echo "   - Make sure you have Python 3.8+ installed: python3 --version"
  echo "   - Try installing setuptools manually: pip install setuptools wheel"
  echo "2. For cx_Oracle issues:"
  echo "   - You need Oracle Instant Client libraries installed"
  echo "   - Run: sudo ./install_oracle_client.sh"
  echo "3. For npm/frontend issues:"
  echo "   - Make sure Node.js is installed: node --version"
  echo "   - Try installing npm dependencies manually: cd frontend && npm install"
  echo ""
  exit 1
}

echo "Vietnam National Hospital Dashboard Setup"
echo "========================================="

# Create Python virtual environment
echo "Setting up Python virtual environment..."
cd backend || handle_error "Could not find backend directory"
python3 -m venv venv || handle_error "Failed to create virtual environment. Make sure python3-venv is installed."
source venv/bin/activate || handle_error "Failed to activate virtual environment"

# Update pip and install setuptools first (needed for Python 3.12+)
echo "Updating pip and installing setuptools..."
pip install --upgrade pip || handle_error "Failed to upgrade pip"
pip install setuptools wheel || handle_error "Failed to install setuptools"

# Install Python dependencies
echo "Installing backend dependencies..."
pip install -r requirements.txt || handle_error "Failed to install Python dependencies"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file for database configuration..."
    cp .env.example .env || handle_error "Failed to create .env file"
    
    # Prompt for database credentials
    echo "Please enter your Oracle database credentials:"
    read -p "Username: " db_user
    read -sp "Password: " db_password
    echo ""
    read -p "Host (default: localhost): " db_host
    db_host=${db_host:-localhost}
    read -p "Port (default: 1521): " db_port
    db_port=${db_port:-1521}
    read -p "Service name (default: xe): " db_service
    db_service=${db_service:-xe}
    
    # Update .env file
    sed -i "s/DB_USER=username/DB_USER=$db_user/" .env
    sed -i "s/DB_PASSWORD=password/DB_PASSWORD=$db_password/" .env
    sed -i "s/DB_HOST=localhost/DB_HOST=$db_host/" .env
    sed -i "s/DB_PORT=1521/DB_PORT=$db_port/" .env
    sed -i "s/DB_SERVICE=xe/DB_SERVICE=$db_service/" .env
    
    echo "Database configuration saved to .env file."
fi

# Return to root directory
cd .. || handle_error "Failed to navigate back to root directory"

# Set up frontend
echo "Setting up frontend..."
cd frontend || handle_error "Could not find frontend directory"
if [ -x "$(command -v npm)" ]; then
    echo "Installing frontend dependencies..."
    npm install || handle_error "Failed to install frontend dependencies"
else
    echo "WARNING: npm not found. Please install Node.js and npm."
    echo "Then run: cd frontend && npm install"
fi

# Return to root directory
cd .. || handle_error "Failed to navigate back to root directory"

# Test database connection
echo "Testing database connection..."
cd backend
source venv/bin/activate
python -c "from config.database import get_connection; conn = get_connection(); print('Database connection successful!' if conn else 'Could not connect to database'); conn.close() if conn else None" || echo "WARNING: Could not connect to the Oracle database. You may need to install Oracle Instant Client."
cd ..

echo "Setup completed!"
echo ""
echo "To start the backend server:"
echo "  cd backend"
echo "  source venv/bin/activate"
echo "  python app.py"
echo ""
echo "To start the frontend development server:"
echo "  cd frontend"
echo "  npm start"
echo ""
echo "Access the application at http://localhost:3000"
echo ""
echo "NOTE: If you encounter issues with cx_Oracle, run:"
echo "  sudo ./install_oracle_client.sh" 