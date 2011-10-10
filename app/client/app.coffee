# Client-side Code

# Bind to socket events
SS.socket.on 'disconnect', ->  $('#message').text('SocketStream server is down :-(')
SS.socket.on 'reconnect', ->   $('#message').text('SocketStream server is up :-)')


# This method is called automatically when the websocket connection is established. Do not rename/delete
exports.init = ->
  scroll = true
  $(window).scroll ->
    if ($(window).scrollTop() + $(window).height() - $("#logs").height()) > -($(window).height() / 5)
      scroll = true
    else
      scroll = false

  # Make a call to the server to retrieve a message
  SS.server.app.init (response) ->
    if response == true
      $('#navigation').addClass("active")
      $('#navigation').removeClass("inactive")
    else
      $('#navigation').removeClass("active")
      $('#navigation').addClass("inactive")
  
  ### START QUICK CHAT DEMO ####

  # Listen for new messages and append them to the screen
  SS.events.on 'newLog', (log, channel) ->
    log.level = log.level.toLowerCase()
    if typeof log.message == "string"
      $("#messageTemplate").tmpl(log).appendTo('#logs').show()
    else
      if log.message.request
        log.message.request.method = log.message.request.method.toLowerCase()
        log.message.request.params = JSON.stringify(log.message.request.params);
        $("#requestTemplate").tmpl(log.message.request).appendTo('#logs').show()
    
    if scroll
      window.scrollTo(0, $("#logs").height())
    console.log log
    
    

isScrolledIntoView = (elem) ->
  docViewTop = $(window).scrollTop()
  docViewBottom = docViewTop + $(window).height()

  elemTop = elem.offset().top
  elemBottom = elemTop + elem.height()

  return ((elemBottom >= docViewTop) && (elemTop <= docViewBottom) && (elemBottom <= docViewBottom) &&  (elemTop >= docViewTop) )