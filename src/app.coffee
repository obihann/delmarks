fs = require 'fs'
url = require 'url'
_ = require 'underscore'

loadDelicious = () ->
	if !@user
		try
			data = fs.readFileSync process.env.HOME + '/.config.dlmrk'
			@user = JSON.parse data
		catch
			return false

	process.env.DELICIOUS_USER = @user.username
	process.env.DELICIOUS_PASSWORD = @user.password

	@nodedelicious = require 'nodedelicious'

title = () ->
	console.log "Delmarks: A node based command line tool for managing your Del.iciou.us bookmarks (1.2)"
	console.log "-----------------------------------------------------------------------------------------"

authError = () ->
	title()
	console.log "Please connect first, try running 'delmarks connect <username> <password>' or if you have recently updated run 'delmarks upgrade'"

parseAll = () ->
	if loadDelicious()
		@nodedelicious.getAllPosts "", "", (err, data) ->
			parseAllResponse data if  !err
	else
		authError()

parseAllResponse = (data) ->
	if data.posts
		posts = data.posts.post

		_.each posts, (link) ->
			console.log link.$.href

deleteLink = (link) ->
	if loadDelicious()

		nodedelicious.deletePost link, (err, data) ->
			title()
			if !err
				console.log "the link (" + link + ") has been removed"
			else
				console.log "an error has occured"
	else
		authError()

newLink = (link) ->
	if loadDelicious()
		link = url.parse link

		nodedelicious.addPost link.href, link.hostname, (err, data) ->
			title()
			if !err
				console.log "the link (" + link + ") has been added"
			else
				console.log "an error has occured"
	else
		authError()

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
	title()
	console.log "connect USERNAME PASSWRD: Connect your account"
	console.log "ls: List your bookmarks"
	console.log "add http://google.ca: Add a new bookmark"
	console.log "remove http://google.ca: Removes a bookmark"
	console.log "upgade: upgrades your account"

upgrade = () ->
	title()
	console.log "Attempting to upgrade user file..."
	fs.rename process.env.HOME + '/config.json', process.env.HOME + '/.config.dlmrk', (err) ->
		if err
			console.log "User file could not be upgreade, please run 'delmarks connect'"
		else
			console.log "Upgrade complete"

switch process.argv[2]
	when "upgrade" then upgrade()
	when "ls" then parseAll()
	when "remove" then deleteLink process.argv[3]
	when "add" then newLink process.argv[3]
	when 'connect' then connect process.argv[3], process.argv[4]
	else help()
