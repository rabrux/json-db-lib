fs   = require 'fs'
path = require 'path'
_Collection = require './Collection'

class JsonDB
  
  constructor : ( @_path = './' ) ->
    # check if specified path exists
    throw "path #{ @_path } do not exists" if not fs.existsSync( @_path )

    # check if specified path is directory
    stats = fs.lstatSync @_path
    throw 'the specified path isnt directory' if not stats.isDirectory()

  Collection : ( name ) ->
    throw 'collection name is required' if not name
    
    new _Collection name, @

  load : ( collectionName ) ->
    file = @generateFilePath collectionName
    data = []
    # load collection from file if exists
    data = JSON.parse( fs.readFileSync( file, 'utf8' ) ) if fs.existsSync file

    throw 'file exists but it isnt a collection' if not Array.isArray( data )

    data

  save : ( collection ) ->
    collectionName = collection.getName()
    collectionData = collection.getData()

    file = @generateFilePath collectionName
    
    fs.writeFileSync file, JSON.stringify( collectionData, null, 2 ), ( err ) ->
    # fs.writeFileSync file, JSON.stringify( collectionData ), ( err ) ->
      throw err if err
      console.log 'saved'
  
  generateFilePath : ( collectionName ) ->
    fileName = collectionName + '.json'
    path.join @getPath(), fileName

  # getters and setters
  getPath : -> @_path
  setPath : ( @_path ) ->

module.exports = JsonDB