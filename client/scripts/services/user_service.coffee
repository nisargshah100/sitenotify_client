App.service 'UserService', (Restangular, $cookies) ->
  @currentUser = null
  @setUser = (@currentUser) ->
    @setToken(@currentUser.token)

  @refresh = ->
    Restangular.all('users').customGET('details').then (data) =>
      @currentUser = data
  
  @logout = ->
    if @currentUser
      Restangular.all('sessions').remove().then ->
        @currentUser = null
        $cookies.token = null
        Restangular.setDefaultRequestParams({ token: null })

  @setToken = (token) ->
    $cookies.token = token
    @initToken()

  @initToken = ->
    if $cookies.token
      Restangular.setDefaultRequestParams({ token: $cookies.token })


  @