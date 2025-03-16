import contextlib
from sqlalchemy.orm import sessionmaker
from ..config.database import get_engine

# Create a sessionmaker for creating sessions
Session = sessionmaker(bind=get_engine())

@contextlib.contextmanager
def get_session():
    """
    Context manager for database sessions.
    Automatically handles commit and rollback.
    """
    session = Session()
    try:
        yield session
        session.commit()
    except Exception as e:
        session.rollback()
        raise
    finally:
        session.close()

def get_all_records(model_class):
    """
    Generic function to get all records for a given model class
    """
    with get_session() as session:
        return session.query(model_class).all()

def get_record_by_id(model_class, record_id, id_column_name='id'):
    """
    Generic function to get a record by ID
    """
    with get_session() as session:
        id_column = getattr(model_class, id_column_name)
        return session.query(model_class).filter(id_column == record_id).first()

def get_related_records(model_class, relationship_column, relationship_value):
    """
    Generic function to get related records
    """
    with get_session() as session:
        column = getattr(model_class, relationship_column)
        return session.query(model_class).filter(column == relationship_value).all()

def run_raw_query(query, params=None):
    """
    Execute a raw SQL query
    """
    with get_session() as session:
        if params:
            result = session.execute(query, params)
        else:
            result = session.execute(query)
        return result 