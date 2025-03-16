"""
Models package for hospital database.
Contains SQLAlchemy models for both SQLite (development) and Oracle (production).
"""

import os

# Import models based on environment
dev_mode = os.getenv('DEV_MODE', 'false').lower() == 'true'

if dev_mode:
    from .sqlite_models import *
else:
    # In the future, Oracle-specific models could be imported here
    from .sqlite_models import * 