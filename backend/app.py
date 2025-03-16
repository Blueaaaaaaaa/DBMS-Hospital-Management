import os
from flask import Flask, jsonify, send_from_directory
from flask_cors import CORS
from dotenv import load_dotenv
from api.endpoints import api

# Load environment variables
load_dotenv()

# Create Flask application
app = Flask(__name__, static_folder='../frontend/build')

# Enable CORS
CORS(app)

# Register API blueprint
app.register_blueprint(api, url_prefix='/api')

# Default route for the API
@app.route('/api', methods=['GET'])
def api_info():
    """API information endpoint"""
    return jsonify({
        "name": "Hospital Management System API",
        "version": "1.0.0",
        "description": "API for Vietnam National Hospital Distributed Database Management System"
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
    # Run app
    app.run(host='0.0.0.0', port=port, debug=True) 