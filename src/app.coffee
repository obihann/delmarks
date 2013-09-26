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

deleteLink = (link) ->
	if loadDelicious()

		nodedelicious.deletePost link, (err, data) ->
			console.log "Gone :)" if !err
	else
		console.log "Please connect first, try running 'delmarks connect username password"

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

help = () ->
	console.log "Delmarks: A node based command line tool for managing your Del.iciou.us bookmarks (0.1.5)"
	console.log "-----------------------------------------------------------------------------------------"
	console.log "connect USERNAME PASSWRD: Connect your account"
	console.log "ls: List your bookmarks"
	console.log "add http://google.ca: Add a new bookmark"

switch process.argv[2]
	when "ls" then parseAll()
	when "remove" then deleteLink process.argv[3]
	when "add" then newLink process.argv[3]
	when 'connect' then connect process.argv[3], process.argv[4]
	else help()
