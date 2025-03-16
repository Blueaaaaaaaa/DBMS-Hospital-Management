#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Default settings
DEV_MODE=true
USE_SQLITE=true

# Ensure we're in the correct directory
# Get the directory of the script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

# Display script location for debugging
echo -e "${BLUE}Script location: ${SCRIPT_DIR}${NC}"

# Change to project root
cd "$PROJECT_ROOT" || { echo -e "${RED}Cannot change to project directory${NC}"; exit 1; }
echo -e "${BLUE}Working from: $(pwd)${NC}"

# Check for Oracle Client installation first using ORACLE_HOME
find_oracle_client() {
    echo -e "${BLUE}Searching for existing Oracle installation...${NC}"
    
    # Check if ORACLE_HOME is set and valid
    if [ -n "$ORACLE_HOME" ] && [ -d "$ORACLE_HOME" ]; then
        echo -e "${GREEN}Found Oracle installation at ${ORACLE_HOME}${NC}"
        if [ -f "$ORACLE_HOME/lib/libclntsh.so" ]; then
            echo -e "${GREEN}Oracle Client libraries found at ${ORACLE_HOME}/lib${NC}"
            export LD_LIBRARY_PATH="$ORACLE_HOME/lib:$LD_LIBRARY_PATH"
            return 0
        elif [ -f "$ORACLE_HOME/lib64/libclntsh.so" ]; then
            echo -e "${GREEN}Oracle Client libraries found at ${ORACLE_HOME}/lib64${NC}"
            export LD_LIBRARY_PATH="$ORACLE_HOME/lib64:$LD_LIBRARY_PATH"
            return 0
        fi
    fi

    echo -e "${YELLOW}ORACLE_HOME not set or does not contain client libraries${NC}"
    
    # Common locations for Oracle Instant Client on Linux
    COMMON_LOCATIONS=(
        "/opt/oracle/instantclient"
        "/opt/oracle/instantclient_21_1"
        "/opt/oracle/instantclient_19_8"
        "/opt/oracle/instantclient_18_5"
        "/opt/oracle/instantclient_12_2"
        "/opt/oracle/product/instantclient"
        "/usr/lib/oracle/21/client64/lib"
        "/usr/lib/oracle/19/client64/lib"
        "/usr/lib/oracle/18/client64/lib"
        "/usr/lib/oracle/12.2/client64/lib"
        "/usr/lib/oracle/12.1/client64/lib"
        "/usr/local/lib/instantclient"
        "/usr/local/instantclient"
        "$HOME/instantclient"
        "$HOME/instantclient_21_1"
        "$HOME/instantclient_19_8"
        "$HOME/instantclient_18_5"
        "$HOME/instantclient_12_2"
        "$HOME/.local/lib/instantclient"
    )
    
    echo -e "${BLUE}Checking common Oracle Instant Client locations...${NC}"
    
    # Check common locations
    for location in "${COMMON_LOCATIONS[@]}"; do
        if [ -d "$location" ]; then
            if [ -f "$location/libclntsh.so" ]; then
                echo -e "${GREEN}Oracle Client libraries found at ${location}${NC}"
                export LD_LIBRARY_PATH="$location:$LD_LIBRARY_PATH"
                return 0
            elif [ -f "$location/lib/libclntsh.so" ]; then
                echo -e "${GREEN}Oracle Client libraries found at ${location}/lib${NC}"
                export LD_LIBRARY_PATH="$location/lib:$LD_LIBRARY_PATH"
                return 0
            fi
        fi
    done
    
    # Search system-wide
    echo -e "${BLUE}Searching system-wide for Oracle libraries (this may take a moment)...${NC}"
    ORACLE_LIBS=$(find /usr /opt /home -path "*/lib*/libclntsh.so*" -type f 2>/dev/null)
    
    if [ -n "$ORACLE_LIBS" ]; then
        ORACLE_LIB_PATH=$(dirname "$(echo "$ORACLE_LIBS" | head -1)")
        echo -e "${GREEN}Oracle Client libraries found at ${ORACLE_LIB_PATH}${NC}"
        export LD_LIBRARY_PATH="$ORACLE_LIB_PATH:$LD_LIBRARY_PATH"
        return 0
    fi
    
    echo -e "${YELLOW}Oracle Client libraries not found.${NC}"
    return 1
}

# Process command line arguments
for arg in "$@"; do
    case $arg in
        --prod|-p)
            DEV_MODE=false
            shift
            ;;
        --dev|-d)
            DEV_MODE=true
            shift
            ;;
        *)
            # Unknown option
            ;;
    esac
done

# Display banner
echo -e "${BOLD}${BLUE}====================================${NC}"
echo -e "${BOLD}${BLUE}  Vietnam National Hospital DBMS   ${NC}"
echo -e "${BOLD}${BLUE}====================================${NC}"

# Check if we need Oracle Client libraries
if [ "$DEV_MODE" = false ]; then
    echo -e "${BOLD}Starting in PRODUCTION mode${NC}"
    
    # Try to find Oracle Client libraries
    if find_oracle_client; then
        echo -e "${GREEN}Oracle Client libraries found. Using Oracle database.${NC}"
        USE_SQLITE=false
    else
        echo -e "${RED}Oracle Client libraries required for production mode but not found.${NC}"
        echo -e "${YELLOW}Options:${NC}"
        echo -e "1. ${BOLD}Install Oracle Instant Client${NC} - Follow the instructions at https://oracle.github.io/odpi/doc/installation.html"
        echo -e "2. ${BOLD}Run in development mode${NC} - Use the --dev flag to run with SQLite"
        echo -e "   Example: ${BOLD}./run.sh --dev${NC}"
        exit 1
    fi
else
    echo -e "${BOLD}Starting in DEVELOPMENT mode${NC}"
    
    # Check if Oracle libraries exist anyway
    if find_oracle_client; then
        echo -e "${GREEN}Oracle Client libraries found. You can use Oracle database even in development mode.${NC}"
        echo -e "${BLUE}However, SQLite will be used by default for easier development.${NC}"
        echo -e "${BLUE}To use Oracle in development mode, modify the .env file and set DEV_MODE=false${NC}"
    else
        echo -e "${YELLOW}Oracle Client libraries not found. Using SQLite database for development.${NC}"
    fi
    
    USE_SQLITE=true
fi

# Check if necessary directories exist
if [ ! -d "backend" ]; then
    echo -e "${RED}Backend directory not found!${NC}"
    echo -e "${RED}Make sure you are running this script from the correct directory.${NC}"
    echo -e "${RED}Current directory: $(pwd)${NC}"
    exit 1
fi

if [ ! -d "frontend" ]; then
    echo -e "${RED}Frontend directory not found!${NC}"
    echo -e "${RED}Make sure you are running this script from the correct directory.${NC}"
    echo -e "${RED}Current directory: $(pwd)${NC}"
    exit 1
fi

# Setup Python virtual environment
setup_venv() {
    echo -e "${BLUE}Setting up Python virtual environment...${NC}"
    cd "$PROJECT_ROOT/backend" || { echo -e "${RED}Backend directory not found${NC}"; exit 1; }
    
    if [ ! -d "venv" ]; then
        echo -e "${BLUE}Creating new virtual environment...${NC}"
        python3 -m venv venv || { echo -e "${RED}Failed to create virtual environment${NC}"; exit 1; }
    fi
    
    # Activate virtual environment
    # shellcheck disable=SC1091
    source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment${NC}"; exit 1; }
    
    # Install dependencies
    echo -e "${BLUE}Installing dependencies...${NC}"
    pip install --upgrade pip
    pip install -r requirements.txt || { echo -e "${RED}Failed to install dependencies${NC}"; exit 1; }
    
    # Create or update .env file
    if [ ! -f ".env" ]; then
        echo -e "${BLUE}Creating .env file...${NC}"
        touch .env
    fi
    
    # Update .env with DEV_MODE setting
    if grep -q "DEV_MODE" .env; then
        sed -i "s/DEV_MODE=.*/DEV_MODE=$DEV_MODE/" .env
    else
        echo "DEV_MODE=$DEV_MODE" >> .env
    fi
    
    echo -e "${GREEN}Backend setup complete${NC}"
    cd "$PROJECT_ROOT" || { echo -e "${RED}Cannot return to project root directory${NC}"; exit 1; }
}

# Setup and start backend server
start_backend() {
    echo -e "${BLUE}Starting backend server...${NC}"
    cd "$PROJECT_ROOT/backend" || { echo -e "${RED}Backend directory not found${NC}"; exit 1; }
    
    # Activate virtual environment if not already activated
    if [ -z "$VIRTUAL_ENV" ]; then
        # shellcheck disable=SC1091
        source venv/bin/activate || { echo -e "${RED}Failed to activate virtual environment${NC}"; exit 1; }
    fi
    
    # Start backend server
    python app.py &
    BACKEND_PID=$!
    echo -e "${GREEN}Backend server started with PID: $BACKEND_PID${NC}"
    cd "$PROJECT_ROOT" || { echo -e "${RED}Cannot return to project root directory${NC}"; exit 1; }
}

# Setup and start frontend server
start_frontend() {
    echo -e "${BLUE}Starting frontend server...${NC}"
    cd "$PROJECT_ROOT/frontend" || { echo -e "${RED}Frontend directory not found${NC}"; exit 1; }
    
    # Check if Node.js is installed
    if ! command -v npm &> /dev/null; then
        echo -e "${YELLOW}npm not found. Is Node.js installed?${NC}"
        echo -e "${YELLOW}Install Node.js and npm, then try again.${NC}"
        return 1
    fi
    
    # Install dependencies if node_modules doesn't exist
    if [ ! -d "node_modules" ]; then
        echo -e "${BLUE}Installing frontend dependencies...${NC}"
        npm install || { echo -e "${RED}Failed to install frontend dependencies${NC}"; return 1; }
    fi
    
    # Start frontend server
    echo -e "${BLUE}Starting development server...${NC}"
    npm start &
    FRONTEND_PID=$!
    echo -e "${GREEN}Frontend server started with PID: $FRONTEND_PID${NC}"
    cd "$PROJECT_ROOT" || { echo -e "${RED}Cannot return to project root directory${NC}"; exit 1; }
}

# Handle shutdown gracefully
handle_shutdown() {
    echo -e "\n${BLUE}Shutting down servers...${NC}"
    if [ -n "$BACKEND_PID" ]; then
        echo -e "${BLUE}Stopping backend server (PID: $BACKEND_PID)...${NC}"
        kill -SIGTERM "$BACKEND_PID" 2>/dev/null || kill -SIGKILL "$BACKEND_PID" 2>/dev/null
    fi
    if [ -n "$FRONTEND_PID" ]; then
        echo -e "${BLUE}Stopping frontend server (PID: $FRONTEND_PID)...${NC}"
        kill -SIGTERM "$FRONTEND_PID" 2>/dev/null || kill -SIGKILL "$FRONTEND_PID" 2>/dev/null
    fi
    echo -e "${GREEN}Shutdown complete${NC}"
    exit 0
}

# Register the shutdown handler
trap handle_shutdown SIGINT SIGTERM

# Main execution
setup_venv
start_backend
start_frontend

echo -e "${GREEN}Both servers are now running.${NC}"
echo -e "${BLUE}Open your browser at ${BOLD}http://localhost:3000${NC} to access the application"
echo -e "${YELLOW}Press Ctrl+C to stop all servers${NC}"

# Keep the script running to handle Ctrl+C
while true; do
    sleep 1
done 