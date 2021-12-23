"""system users interactions"""
import os
import pwd
import grp


class User:
    """system users interactions"""
    users = []

    def __init__(self):
        self.users = self.get_all_users()

    def user_exists(self, username):
        """check if a user exists by username"""
        return username in self.users

    @staticmethod
    def get_all_users():
        """load all users out of the system groups"""
        users = []
        groups = grp.getgrall()

        for group in groups:
            for user in group[3]:
                users.append(user)

        return list(dict.fromkeys(users))

    @staticmethod
    def get_current_user():
        """get current user by system uid"""
        return pwd.getpwuid(os.getuid()).pw_name
