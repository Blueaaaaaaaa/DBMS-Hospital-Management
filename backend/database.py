import os
import sys
import logging
from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.exc import SQLAlchemyError

# Set up logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

def create_connection_string():
    """Create connection string for Oracle database from environment variables"""
    DB_USER = os.getenv('DB_USER')
    DB_PASSWORD = os.getenv('DB_PASSWORD')
    DB_HOST = os.getenv('DB_HOST')
    DB_PORT = os.getenv('DB_PORT')
    DB_SERVICE = os.getenv('DB_SERVICE')

    # Check if all required environment variables are set
    if not all([DB_USER, DB_PASSWORD, DB_HOST, DB_PORT, DB_SERVICE]):
        logger.warning("Some Oracle database environment variables are missing.")
        return None

    # Create connection string
    conn_str = f"oracle+cx_oracle://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/?service_name={DB_SERVICE}"
    return conn_str

def get_db_engine():
    """Get database engine"""
    # Check if DEV_MODE is enabled
    dev_mode = os.getenv('DEV_MODE', 'false').lower() == 'true'
    
    if dev_mode:
        # Use SQLite in development mode
        logger.info("Using SQLite database in development mode")
        
        # Create data directory if it doesn't exist
        data_dir = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'data')
        if not os.path.exists(data_dir):
            os.makedirs(data_dir)
        
        # Initialize SQLite database with models
        db_path = os.path.join(data_dir, 'hospital.db')
        logger.info(f"SQLite database path: {db_path}")
        
        # Import SQLite models and initialize database
        try:
            from models.sqlite_models import initialize_sqlite_db
            return initialize_sqlite_db(db_path)
        except ImportError as e:
            logger.error(f"Failed to import SQLite models: {e}")
            sys.exit(1)
    else:
        # Use Oracle in production mode
        logger.info("Using Oracle database in production mode")
        
        try:
            # Get connection string
            conn_str = create_connection_string()
            if not conn_str:
                logger.error("Failed to create Oracle connection string")
                sys.exit(1)
            
            # Create engine
            engine = create_engine(conn_str)
            
            # Test connection
            engine.connect().close()
            logger.info("Successfully connected to Oracle database")
            
            return engine
        except ModuleNotFoundError as e:
            logger.error(f"Error: Oracle client libraries not found or cx_Oracle module not installed: {e}")
            logger.error("Please install Oracle Instant Client and cx_Oracle package.")
            sys.exit(1)
        except SQLAlchemyError as e:
            logger.error(f"Database connection error: {e}")
            sys.exit(1) 