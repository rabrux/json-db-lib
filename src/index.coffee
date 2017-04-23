fs   = require 'fs'
path = require 'path'

class JsonDB
  
  constructor : ( @_path = './' ) ->

    stats = fs.lstatSync @_path
    throw 'the specified path isnt directory' if not stats.isDirectory()
    @setPath path.join @_path

  save : ( collection ) ->
    collectionName = collection.getName()
    collectionData = collection.getData()
    fileName = collectionName + '.json'
    filePath = path.join @getPath(), fileName
    
    fs.writeFileSync filePath, JSON.stringify( collectionData, null, 2 ), ( err ) ->
    # fs.writeFileSync filePath, JSON.stringify( collectionData ), ( err ) ->
      throw err if err
      console.log 'saved'

  # getters and setters
  getPath : -> @_path
  setPath : ( @_path ) ->

class Collection
  
  constructor : ( @_name, @__driver, @_data = [] ) ->

  insert : ( item ) ->
    @getData().push item
    @save()

  find : ( query = {} ) ->
    it = @
    @getData().filter ( item, index ) ->
      return item if it.compare( item, query )
  
  compare : ( item, query ) ->
    flag = true
    for k, v of query
      flag = false if item[ k ] isnt v

    flag

  update : ( query = {}, replace = {} ) ->
    ocurrences = @find query
    changed    = ocurrences.length
    
    while i = ocurrences.shift()
      index = @getData().indexOf i
      Object.assign @getData()[ index ], replace
    
    @save()
    changed

  remove : ( query = {} ) ->
    ocurrences = @find query
    removed    = ocurrences.length
    
    while i = ocurrences.shift()
      index = @getData().indexOf i
      @getData().splice index, 1

    @save()
    removed

  save : ->
    @getDriver().save @

  # getters and setters
  getData : -> @_data
  setData : ( @_data = [] ) ->

  getName : -> @_name
  setName : ( @_name ) ->

  getDriver : -> @__driver