"""shell interaction"""
import subprocess
from . import Logger, User

log = Logger.get('cmd')


class Cmd:
    """shell interaction"""

    @staticmethod
    def exec(cmd, exec_user='', log_cmd=True, io_stream_type=0,
             ignore_error=False):
        """
        run shell commands with optional io stream
        io_stream_type: 0=stdout, 1=internal, 2=log, 3=suppressed
        """
        if exec_user == '' or not User().user_exists(exec_user):
            exec_user = User.get_current_user()

        exec_cmd = ["sudo", "-i", "-u", exec_user,
                    "-H", "bash", "-c", cmd]

        if log_cmd:
            log.info(f"exec: {cmd}", extra={'user': exec_user})
        else:
            log.debug(f"exec: {cmd}", extra={'user': exec_user})

        if io_stream_type == 0:
            with subprocess.Popen(exec_cmd) as proc:
                if proc.returncode == 0:
                    return True
                return False
        else:
            with subprocess.Popen(exec_cmd,
                                  stderr=subprocess.PIPE,
                                  stdout=subprocess.PIPE) as proc:
                res_code = proc.returncode
                if io_stream_type == 1:
                    if res_code == 0:
                        return res_code, proc.stdout.read().decode('utf-8')
                    return res_code, proc.stderr.read().decode('utf-8')
                elif io_stream_type == 2:
                    if res_code == 0:
                        log_msg = proc.stdout.read().decode(
                            'utf-8').replace('\n', '')
                        log.info(f"out: {log_msg}",
                                 extra={'cmd': cmd, 'user': exec_user})
                    else:
                        log_err = proc.stderr.read().decode(
                            'utf-8').replace('\n', '')
                        extra = {'cmd': cmd, 'user': exec_user}
                        if res_code is not None:
                            extra['code'] = res_code
                        if ignore_error:
                            log.debug(f"{log_err}",
                                      extra={'cmd': cmd,
                                             'code': res_code,
                                             'user': exec_user})
                        else:
                            log.warning(f"{log_err}",
                                        extra={'cmd': cmd,
                                               'code': res_code,
                                               'user': exec_user})

    @staticmethod
    def exec_suppress(cmd, exec_user=''):
        """run cmd without any output"""
        return Cmd.exec(cmd, exec_user, False, 0)
