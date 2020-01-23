import logging
import logging.config
import yaml

def func1():
    a = 5
    b = 0

    try:
        c = a / b
        print(c)
    except Exception:
        sampleLogger.error("Exception occurred", exc_info=True)

with open('config_console_file.yaml', 'r') as f:
    config = yaml.safe_load(f.read())
    logging.config.dictConfig(config)

sampleLogger = logging.getLogger(__name__)

sampleLogger.warning('This is a warning message')

# raising an error
func1()