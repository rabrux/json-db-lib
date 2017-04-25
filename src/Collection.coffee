class Collection
    
  constructor : ( @_name, @__driver ) ->
    # load data if collection exists
    @setData @getDriver().load( @_name )

  insert : ( item ) ->
    @getData().push item
    @save()

  findOne : ( query = {}, cb ) ->
    result = @find( query ).shift()
    return cb result if cb
    result

  find : ( query = {}, cb ) ->
    it = @
    result = @getData().filter ( item, index ) ->
      return item if it.compare( item, query )

    return cb result if cb
    result
  
  compare : ( item, query ) ->
    flag = true
    for k, v of query
      flag = false if item[ k ] isnt v

    flag

  update : ( query = {}, replace = {}, cb ) ->
    ocurrences = @find query
    changed    = ocurrences.length
    
    while i = ocurrences.shift()
      index = @getData().indexOf i
      Object.assign @getData()[ index ], replace
    
    @save()
    return cb changed if cb
    changed

  remove : ( query = {}, cb ) ->
    ocurrences = @find query
    removed    = ocurrences.length
    
    while i = ocurrences.shift()
      index = @getData().indexOf i
      @getData().splice index, 1

    @save()
    return cb removed if cb
    removed

  save : ->
    @getDriver().save @

  # getters and setters
  getData : -> @_data
  setData : ( @_data = [] ) ->

  getName : -> @_name
  setName : ( @_name ) ->

  getDriver : -> @__driver


module.exports = Collection
