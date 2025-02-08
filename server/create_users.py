from fishtest.rundb import RunDb
rdb = RunDb()
for i in range(2):
    user_name = f"user{i:02d}"
    user_mail = f"{user_name}@example.org"
    user_repo = "https://github.com/official-stockfish/Stockfish"
    rdb.userdb.create_user(user_name, user_name, user_mail, user_repo)
    if i == 0:
        rdb.userdb.add_user_group(user_name, "group:approvers")
    user = rdb.userdb.get_user(user_name)
    user["blocked"] = False
    user["pending"] = False
    user["machine_limit"] = 100
    rdb.userdb.save_user(user)