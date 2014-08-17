App.service 'UserService', (Restangular, $cookies) ->
  @currentUser = null
  @beforeLoginPath = null

  @setUser = (@currentUser) ->
    @setToken(@currentUser.token)

  @refresh = (cb) ->
    Restangular.all('users').customGET('details').then (data) =>
      @currentUser = data
      cb() if cb?
  
  @logout = ->
    if @currentUser
      Restangular.all('sessions').remove().then ->
        @currentUser = null
        $cookies.token = ""
        Restangular.setDefaultRequestParams({ token: "" })

  @setToken = (token) ->
    $cookies.token = token
    @initToken()

  @getToken = ->
    @currentUser.token || $cookies.token

  @getAndResetLoginPath = ->
    old = @beforeLoginPath
    @beforeLoginPath = null
    old

  @initToken = ->
    if $cookies.token
      Restangular.setDefaultRequestParams({ token: $cookies.token })
    else
      @beforeLoginPath = location.href


  @