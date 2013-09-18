config = require './config'
_ = require 'underscore'
nodedelicious = require 'nodedelicious'

parseAll = () ->
	nodedelicious.getAllPosts "", "", (err, data) ->
		parseAllResponse data if  !err

parseAllResponse = (data) ->
	if data.posts
		console.log data.posts.$
		posts = data.posts.post

		_.each posts, (link) ->
			console.log link.$.href

newLink = (link, desc) ->
	nodedelicious.addPost link, desc, (err, data) ->
		console.log data if !err
		console.log err if err

switch process.argv[2]
	when "ls" then parseAll()
	when "add" then newLink process.argv[3], process.argv[4]
