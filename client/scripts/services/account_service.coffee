App.service 'AccountService', (Restangular, $cookies, UserService) ->
  @current = null
  @currentAccountMembers = []
  @currentAccountInvites = []
  @accounts = []
  
  @refresh = ->
    Restangular.all('accounts').getList().then (data) =>
      @accounts = data
      @loadCurrent()

  @setCurrent = (acc) ->
    newCurrent = _.find @accounts, ((a) -> a.id == acc.id)
    if newCurrent
      @current = newCurrent
      $cookies.currentAccountId = @current.id

  @loadCurrent = ->
    if $cookies.currentAccountId
      @current = _.find @accounts, ((a) -> parseInt($cookies.currentAccountId) == a.id)
      $cookies.currentAccountId = null if not @current

    if not @current
      @current = _.find @accounts, ((a) -> UserService.currentUser?.default_account_id == a.id)

    if not @current
      @current = _.first(@accounts)

    if @current
      $cookies.currentAccountId = @current.id
  
  @fetchMembers = (acc) ->
    acc ||= @current
    Restangular.one('accounts', acc.id).customGET('members').then (data) =>
      @currentAccountMembers = data

  @fetchInvites = (acc) ->
    acc ||= @current
    Restangular.one('accounts', acc.id).all('account_invites').getList().then (data) =>
      @currentAccountInvites = data

  @