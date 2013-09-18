_ = require 'underscore'
nodedelicious = require 'nodedelicious'

parseAll = () ->
	nodedelicious.getAll "", "", (err, data) ->
		parseAllResponse data if  !err

parseAllResponse = (data) ->
	if data.posts
		console.log data.posts.$
		posts = data.posts.post

		_.each posts, (link) ->
			console.log link.$.href

process.argv.forEach (val, index, array) ->
  switch val
  	when "ls" then parseAll()