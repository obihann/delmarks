fs = require 'fs'
url = require 'url'
_ = require 'underscore'

loadDelicious = () ->
	if !@user
		try
			data = fs.readFileSync './config.json'
			@user = JSON.parse data
		catch
			return false

	process.env.DELICIOUS_USER = @user.username
	process.env.DELICIOUS_PASSWORD = @user.password

	@nodedelicious = require 'nodedelicious'

	true

parseAll = () ->
	if loadDelicious()
		@nodedelicious.getAllPosts "", "", (err, data) ->
			parseAllResponse data if  !err
	else
		console.log "Please connect first, try running 'delmarks connect username password"

parseAllResponse = (data) ->
	if data.posts
		posts = data.posts.post

		_.each posts, (link) ->
			console.log link.$.href
	else
		console.log data

newLink = (link) ->
	if loadDelicious()
		link = url.parse link

		nodedelicious.addPost link.href, link.hostname, (err, data) ->
			console.log "Done :)" if !err
	else
		console.log "Please connect first, try running 'delmarks connect username password"

connect = (username, password) ->
	@user = {
		username: username
		password: password
	}

	data = JSON.stringify user

	fs.writeFile './config.json', data, (err) ->
		console.log err.message if err

	loadDelicious()

switch process.argv[2]
	when "ls" then parseAll()
	when "add" then newLink process.argv[3]
	when 'connect' then connect process.argv[3], process.argv[4]
