from .settings import *

# Override these settings with local settings if such a file exists
try:
    from .override_settings import *
except ImportError as e:
    pass