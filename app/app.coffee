config = require './config'
url = require 'url'
_ = require 'underscore'
nodedelicious = require 'nodedelicious'

parseAll = () ->
	nodedelicious.getAllPosts "", "", (err, data) ->
		parseAllResponse data if  !err

parseAllResponse = (data) ->
	if data.posts
		posts = data.posts.post

		_.each posts, (link) ->
			console.log link.$.href
	else
		console.log data

newLink = (link) ->
	link = url.parse link

	nodedelicious.addPost link.href, link.hostname, (err, data) ->
		console.log "Done :)" if !err

switch process.argv[2]
	when "ls" then parseAll()
	when "add" then newLink process.argv[3]
