import os
import cx_Oracle
from dotenv import load_dotenv
from sqlalchemy import create_engine

# Load environment variables
load_dotenv()

# Oracle database connection parameters
DB_USER = os.getenv('DB_USER', 'username')
DB_PASSWORD = os.getenv('DB_PASSWORD', 'password')
DB_HOST = os.getenv('DB_HOST', 'localhost')
DB_PORT = os.getenv('DB_PORT', '1521')
DB_SERVICE = os.getenv('DB_SERVICE', 'xe')

# Connection string for cx_Oracle
CONNECTION_STRING = f"{DB_USER}/{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_SERVICE}"

# DSN for SQLAlchemy
DSN = cx_Oracle.makedsn(DB_HOST, DB_PORT, service_name=DB_SERVICE)
SQLALCHEMY_DATABASE_URI = f"oracle://{DB_USER}:{DB_PASSWORD}@{DSN}"

def get_connection():
    """
    Creates and returns a connection to the Oracle database
    """
    try:
        connection = cx_Oracle.connect(CONNECTION_STRING)
        return connection
    except cx_Oracle.Error as error:
        print(f"Error connecting to Oracle database: {error}")
        raise

def get_engine():
    """
    Creates and returns a SQLAlchemy engine
    """
    try:
        engine = create_engine(SQLALCHEMY_DATABASE_URI)
        return engine
    except Exception as e:
        print(f"Error creating SQLAlchemy engine: {e}")
        raise 