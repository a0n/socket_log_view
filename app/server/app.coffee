# Server-side Code
_ = require('underscore')._


getAllSets = (cb) ->
  R.smembers "logger:sets", (err, sets) ->
    cb(sets)

getTstampsForSet = (set, cb) ->
  R.smembers "logger:set:" + set, (err, tstamps) ->
    cb(tstamps)

getEntriesForSet = (set ,cb) ->
  all_entries = R.multi()
  getTstampsForSet set, (tstamps) ->
    _.each tstamps, (tstamp) ->
      all_entries.hgetall "log:" + tstamp
    all_entries.exec (err, logs) ->
      cb logs

      
exports.actions =
  
  init: (cb) ->
    @session.channel.subscribe("WARN")
    @session.channel.subscribe("FATAL")
    @session.channel.subscribe("INFO")
    @session.channel.subscribe("DEBUG")
    cb true
  
  get_levels: (cb) ->
    R.smembers "levels", (err, levels) ->
      if err
        cb err
      else
        cb levels
        
  
  subscribe: (level, cb) ->
    cb @session.channel.subscribe(level)
    
    
  unsubscribe: (level, cb) ->
    cb @session.channel.unsubscribe(level)
  
  
  # Quick Chat Demo
#  sendMessage: (message, cb) ->
#    if message.length > 0                             # Check for blank messages
#      SS.publish.broadcast 'newMessage', message      # Broadcast the message to everyone
#      cb true                                         # Confirm it was sent to the originating client
#    else
#      cb false
