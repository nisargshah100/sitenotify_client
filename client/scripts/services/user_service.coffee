App.service 'UserService', (Restangular) ->
  @currentUser = null
  @setUser = (@currentUser) ->
  @refresh = ->
    Restangular.all('users').customGET('details').then (data) =>
      @currentUser = data
  @logout = ->
    if @currentUser
      Restangular.all('sessions').remove().then ->
        @currentUser = null

  @