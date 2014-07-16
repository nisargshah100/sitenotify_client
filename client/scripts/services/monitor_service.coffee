App.service 'MonitorService', (Restangular, AccountService) ->
  @monitors = []
  @current = null
  
  @refresh = ->
    AccountService.current.getList('site_monitors').then (data) =>
      @monitors = data

  @setCurrent = (id) ->
    @current = _.find(@monitors, ((x) -> x.id == id))
  
  @