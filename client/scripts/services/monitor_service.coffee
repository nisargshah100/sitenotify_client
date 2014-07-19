App.service 'MonitorService', (Restangular, AccountService) ->
  @monitors = []
  @current = null
  @currentStats = {}
  
  @getStats = (id, startDate = null, endDate = null) ->
    AccountService.current.one('site_monitors', id).customGET('stats', {start_date: startDate, end_date: endDate}).then (data) =>
      @currentStats = data

  @refresh = (cb) ->
    AccountService.current.getList('site_monitors').then (data) =>
      @monitors = data
      cb() if cb

  @setCurrent = (id) ->
    @current = _.find(@monitors, ((x) -> x.id == id))
  
  @