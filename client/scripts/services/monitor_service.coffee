App.service 'MonitorService', (Restangular, AccountService) ->
  @monitors = []
  @current = null
  
  @refresh = (cb) ->
    AccountService.current.getList('site_monitors').then (data) =>
      @monitors = data
      cb() if cb

  @setCurrent = (id) ->
    @current = _.find(@monitors, ((x) -> x.id == id))
  
  @