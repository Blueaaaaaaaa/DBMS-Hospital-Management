#!/bin/bash

echo "Vietnam National Hospital Dashboard Setup"
echo "========================================="

# Create Python virtual environment
echo "Setting up Python virtual environment..."
cd backend
python3 -m venv venv
source venv/bin/activate

# Install Python dependencies
echo "Installing backend dependencies..."
pip install -r requirements.txt

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "Creating .env file for database configuration..."
    cp .env.example .env
    
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
cd ..

# Set up frontend
echo "Setting up frontend..."
cd frontend
if [ -x "$(command -v npm)" ]; then
    echo "Installing frontend dependencies..."
    npm install
else
    echo "WARNING: npm not found. Please install Node.js and npm."
    echo "Then run: cd frontend && npm install"
fi

# Return to root directory
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