App.service 'UserService', (Restangular) ->
  @currentUser = null
  @setUser = (@currentUser = user) ->
  @refresh = ->
    Restangular.all('users').customGET('details').then (data) =>
      @currentUser = data.user
  @
  