"""logger implementation"""
import logging


class Logger():
    """logger helper utils"""

    @staticmethod
    def load(level='DEBUG'):
        """create the logger instance at the start of the programm"""
        log = logging.getLogger()
        log.setLevel(level)
        log.addHandler(LogHandler())
        log = LogPrefixAdapter(log, 'root')
        log = LogExtraAdapter(log)
        return log

    @staticmethod
    def get(area=''):
        """load the existing logger instance in sub-modules"""
        log = logging.getLogger()
        if area != '':
            log = LogPrefixAdapter(log, area)
        log = LogExtraAdapter(log)
        return log


class LogHandler(logging.StreamHandler):
    """custom formatter for logger"""

    grey = "\x1b[38;21m"
    blue = "\x1b[1;34m"
    green = "\x1b[1;32m"
    yellow = "\x1b[33;21m"
    red = "\x1b[31;21m"
    bold_red = "\x1b[31;1m"
    reset = "\x1b[0m"

    fmt = '%(asctime)s.%(msecs)03d %(message)s'
    fmt_date = '%H:%M:%S'

    FORMATS = {
        logging.DEBUG: blue,
        logging.INFO: green,
        logging.WARNING: yellow,
        logging.ERROR: red,
        logging.CRITICAL: bold_red
    }

    def format(self, record):
        lvl_space = " " * (9 - len(logging.getLevelName(record.levelno)))
        log_fmt = self.FORMATS.get(record.levelno)
        log_fmt = log_fmt + f"%(levelname)s\x1b[0m{lvl_space} " + self.fmt
        formatter = logging.Formatter(log_fmt, self.fmt_date)
        return formatter.format(record)


class LogPrefixAdapter(logging.LoggerAdapter):
    """add the module name at start of log message"""

    def __init__(self, logger, prefix):
        super().__init__(logger, {})
        self.prefix = prefix

    def process(self, msg, kwargs):
        space = " " * (6 - len(self.prefix))
        return f"[{self.prefix}]{space}: {msg}", kwargs


class LogExtraAdapter(logging.LoggerAdapter):
    """add extra arguments at the end of the log message"""

    def __init__(self, logger):
        super().__init__(logger, {})

    def process(self, msg, kwargs):
        extras = kwargs["extra"]
        fmt = "{"
        for key in extras:
            fmt = fmt + f"{key}: {extras[key]}, "
        fmt = fmt[:-2] + "}"
        return f"{msg} {fmt}", kwargs
