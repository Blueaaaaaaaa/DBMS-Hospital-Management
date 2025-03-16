import os
import logging
from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
from dotenv import load_dotenv
from api.endpoints import api
from database import get_db_engine

# Set up logging
logging.basicConfig(level=logging.INFO, 
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Check if we're in development mode
DEV_MODE = os.getenv('DEV_MODE', 'false').lower() in ('true', '1', 't')
if DEV_MODE:
    logger.info("Running in DEVELOPMENT mode with SQLite fallback")
else:
    logger.info("Running in PRODUCTION mode, Oracle required")

# Create Flask application
app = Flask(__name__, static_folder='../frontend/build')

# Enable CORS
CORS(app)

# Register API blueprint
app.register_blueprint(api, url_prefix='/api')

# Get database engine
try:
    db_engine = get_db_engine()
    logger.info("Database engine initialized successfully")
except Exception as e:
    logger.error(f"Failed to initialize database engine: {e}")
    db_engine = None

# Default route for the API
@app.route('/api', methods=['GET'])
def api_info():
    """API information endpoint"""
    return jsonify({
        "name": "Hospital Management System API",
        "version": "1.0.0",
        "description": "API for Vietnam National Hospital Distributed Database Management System",
        "mode": "Development" if DEV_MODE else "Production"
    })

# Health check endpoint
@app.route('/api/health', methods=['GET'])
def health_check():
    """Health check endpoint"""
    status = "ok" if db_engine else "database_error"
    dev_mode = os.getenv('DEV_MODE', 'false').lower() == 'true'
    return jsonify({
        "status": status,
        "mode": "development" if dev_mode else "production"
    })

# Serve React App - for production
@app.route('/', defaults={'path': ''})
@app.route('/<path:path>')
def serve(path):
    if path and os.path.exists(os.path.join(app.static_folder, path)):
        return send_from_directory(app.static_folder, path)
    else:
        return send_from_directory(app.static_folder, 'index.html')

if __name__ == '__main__':
    # Get port from environment variable or use default
    port = int(os.environ.get('PORT', 5000))
    
    # Log startup information
    logger.info(f"Starting Hospital Management System API on port {port}")
    logger.info(f"Environment: {os.environ.get('FLASK_ENV', 'development')}")
    
    # Run app
    app.run(host='0.0.0.0', port=port, debug=True) 