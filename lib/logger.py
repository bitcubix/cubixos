"""logger implementation"""
import logging


class Logger():
    """logger helper utils"""

    @staticmethod
    def load(level='DEBUG'):
        """create the logger instance at the start of the programm"""
        log = logging.getLogger('root')
        log.setLevel(level)
        log.addHandler(LogHandler())
        return log

    @staticmethod
    def get(area='root'):
        """load the existing logger instance in sub-modules"""
        return logging.getLogger(area)


class LogHandler(logging.StreamHandler):
    """custom formatter for logger"""

    grey = "\x1b[38;21m"
    blue = "\x1b[1;34m"
    green = "\x1b[1;32m"
    yellow = "\x1b[33;21m"
    red = "\x1b[31;21m"
    bold_red = "\x1b[31;1m"
    reset = "\x1b[0m"

    fmt = '%(levelname)-8s \x1b[0m %(asctime)s - %(filename)-12s: %(message)s'
    fmt_date = '%Y-%m-%d %H:%M:%S,uu'

    FORMATS = {
        logging.DEBUG: blue + fmt,
        logging.INFO: green + fmt,
        logging.WARNING: yellow + fmt,
        logging.ERROR: red + fmt,
        logging.CRITICAL: bold_red + fmt
    }

    def format(self, record):
        log_fmt = self.FORMATS.get(record.levelno)
        formatter = logging.Formatter(log_fmt)
        return formatter.format(record)
