fs = require 'fs'

db =
	path: null
	tableFile: null

db.connect = ( path ) ->
	if path
		try
			stats = fs.lstatSync( path )
			if stats.isDirectory()
				@path = path.replace( /\/$/, '' ) + '/'
			else
				throw 'Invalid directory'
				process.exit(1)
		catch e
			console.log e
	else
		throw 'Undefined path'
	return

db.load = ( table, init ) ->
	if table
		try
			@table = JSON.parse fs.readFileSync( @path + table + '.json', 'utf8' )
			@tableFile = table + '.json'
		catch e
			@table = init
			@tableFile = table + '.json'
			@save()
	return

db.insert = ( table, obj ) ->
	@load table

	@table.push obj

	return @save()

db.select = ( table, query, values ) ->

	query = query || '1=1'

	@load table

	result = []

	r = []
	for i in query.split( /\s(AND|OR)\s/ )
		if i != 'AND' and i != 'OR'
			i = 'i.' + i
		r.push i

	query = r.join( ' ' )

	for k, v of values
		if typeof v == 'string'
			query = query.split( k ).join( '"' + v + '"' )
		else
			query = query.split( k ).join( v )

	query = query.split( ' AND ' ).join( ' && ' )
	query = query.split( ' OR ' ).join( ' || ' )

	query = 'e = ' + query

	for i in db.table
		eval( query )
		if e
			result.push i

	return result

db.update = ( table, obj, find ) ->

	query = []

	for k, v of find
		if typeof v == 'string'
			query.push 'i.' + k + ' == "' + v + '"'
		else
			query.push 'i.' + k + ' == ' + v

	query = 'e = ' + query.join( ' AND ' )

	for i in @table
		eval query
		if e
			i = obj

	return @save()

db.delete = ( table, query, values ) ->
	@load table

	result = []

	r = []
	for i in query.split( /\s(AND|OR)\s/ )
		if i != 'AND' and i != 'OR'
			i = 'i.' + i
		r.push i

	query = r.join( ' ' )

	for k, v of values
		if typeof v == 'string'
			query = query.split( k ).join( '"' + v + '"' )
		else
			query = query.split( k ).join( v )

	query = query.split( ' AND ' ).join( ' && ' )
	query = query.split( ' OR ' ).join( ' || ' )

	query = 'e = ' + query

	delIndex = []
	pos = 0
	for i in @table
		eval( query )
		if e
			delIndex.push pos
		pos++

	while delIndex.length > 0
		@table.splice delIndex.pop(), 1

	return @save()

db.save = ->
	fs.writeFile @path + @tableFile, JSON.stringify( @table, null, 4 ), (err) ->
		if err
			return false
	return true

module.exports = db
