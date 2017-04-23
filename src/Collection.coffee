class Collection
    
  constructor : ( @_name, @__driver ) ->
    # load data if collection exists
    @setData @getDriver().load( @_name )

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


module.exports = Collection