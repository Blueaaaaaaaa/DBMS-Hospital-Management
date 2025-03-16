import os
import sys
from dotenv import load_dotenv
import logging

# Set up logging
logging.basicConfig(level=logging.INFO, 
                    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

# Load environment variables
load_dotenv()

# Check if we're in development mode
DEV_MODE = os.getenv('DEV_MODE', 'false').lower() in ('true', '1', 't')

# Oracle database connection parameters
DB_USER = os.getenv('DB_USER', 'username')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '1521')
DB_SERVICE = os.getenv('DB_SERVICE', 'xe')

# Connection string for cx_Oracle
CONNECTION_STRING = f"{DB_USER}/{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_SERVICE}"

# SQLite file location (for dev mode)
SQLITE_FILE = os.path.join(os.path.dirname(os.path.dirname(os.path.abspath(__file__))), 'dev.db')

try:
    import cx_Oracle
    # DSN for SQLAlchemy
    DSN = cx_Oracle.makedsn(DB_HOST, DB_PORT, service_name=DB_SERVICE)
    SQLALCHEMY_DATABASE_URI = f"oracle://{DB_USER}:{DB_PASSWORD}@{DSN}"
    
    def get_connection():
        """
        Creates and returns a connection to the Oracle database
        """
        try:
            connection = cx_Oracle.connect(CONNECTION_STRING)
            logger.info("Successfully connected to Oracle database")
            return connection
        except cx_Oracle.Error as error:
            logger.error(f"Error connecting to Oracle database: {error}")
            if DEV_MODE:
                logger.warning("Using SQLite in development mode")
                return None
            raise

    def get_engine():
        """
        Creates and returns a SQLAlchemy engine
        """
        try:
            from sqlalchemy import create_engine
            engine = create_engine(SQLALCHEMY_DATABASE_URI)
            return engine
        except Exception as e:
            logger.error(f"Error creating SQLAlchemy engine: {e}")
            if DEV_MODE:
                logger.warning(f"Using SQLite in development mode: {SQLITE_FILE}")
                return create_engine(f"sqlite:///{SQLITE_FILE}")
            raise
            
except ImportError:
    logger.error("""
    ERROR: Could not import cx_Oracle. Make sure it's installed correctly.
    
    This could be due to:
    1. cx_Oracle not being installed: pip install cx_Oracle
    2. Oracle Client libraries not being installed on your system
    
    To install Oracle Client libraries, you need the Oracle Instant Client.
    """)
    
    # Use SQLite for development without Oracle
    if DEV_MODE:
        logger.warning(f"Using SQLite in development mode: {SQLITE_FILE}")
        from sqlalchemy import create_engine
        SQLALCHEMY_DATABASE_URI = f"sqlite:///{SQLITE_FILE}"
        
        def get_connection():
            logger.warning("Using dummy connection with SQLite - Oracle not available")
            return None
            
        def get_engine():
            logger.warning(f"Using SQLite engine: {SQLITE_FILE}")
            return create_engine(SQLALCHEMY_DATABASE_URI)
    else:
        # In production, exit if Oracle is required
        logger.critical("Cannot run in production without Oracle")
        
        def get_connection():
            logger.error("Oracle connection not available")
            return None
            
        def get_engine():
            logger.error("Oracle engine not available")
            from sqlalchemy import create_engine
            return create_engine('sqlite:///dummy.db')
            
        if os.getenv('FLASK_ENV') == 'production':
            sys.exit(1) 