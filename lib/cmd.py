"""shell interaction"""
import subprocess
from user import User


class Cmd:
    """shell interaction"""

    @staticmethod
    def exec(cmd, exec_user='', log_cmd=True, io_stream_type=0):
        """
        run shell commands with optional io stream
        io_stream_type: 0=none, 1=stdout, 2=log
        """
        if exec_user == '' or not User().user_exists(exec_user):
            exec_user = User.get_current_user()

        exec_cmd = f"sudo -i -u {exec_user} -H bash -c '{cmd}'"

        if log_cmd:
            #TODO use logger to log cmd

        if io_stream_type == 0:
            exec_cmd = exec_cmd + ' &> /dev/null'
            res = subprocess.run(exec_cmd, shell=True, check=True)
        if io_stream_type == 1:
            res = subprocess.run(exec_cmd, shell=True,
                                 encoding='utf-8', capture_output=True, check=True)
            if res.returncode != 0:
                print(res.stderr)
            else:
                print(res.stdout)
        if io_stream_type == 2:
            res = subprocess.run(exec_cmd, shell=True, check=True)
            if res.returncode != 0:
                print('log stderr')
            else:
                print('log stdout')

        if res.returncode == 0:
            return True

        return False

    @staticmethod
    def exec_suppress(cmd, exec_user=''):
        """run cmd without any output"""
        return Cmd.exec(cmd, exec_user, False, 0)
