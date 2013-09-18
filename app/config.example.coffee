config = {
	delicious_user = "username"
	password = "password"
}

process.env.DELICIOUS_USER = config.user
process.env.DELICIOUS_PASSWORD = config.password

modules.expor config