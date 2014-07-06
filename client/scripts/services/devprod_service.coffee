App.service 'DevProdService', ->
  @isProd = ->
    @host() == 'sitenotify.net'
  @isDev = ->
    !@isProd()
  @host = ->
    window.location.hostname.replace('www.', '')
  @