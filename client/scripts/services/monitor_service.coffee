App.service 'MonitorService', (Restangular, AccountService) ->
  @monitors = []
  @current = null
  @currentStats = {}
  @lastFailed = []
  
  @getStats = (id, startDate = null, endDate = null) ->
    AccountService.current.one('site_monitors', id).customGET('stats', {start_date: startDate, end_date: endDate}).then (data) =>
      @currentStats = data

  @refresh = (cb) ->
    AccountService.current.getList('site_monitors').then (data) =>
      @monitors = data
      cb() if cb

  @setCurrent = (id) ->
    @current = _.find(@monitors, ((x) -> x.id == id))
  
  @getLastFailed = (limit) ->
    return unless @current
    limit ||= 5
    AccountService.current.one('site_monitors', @current.id).customGET('stats/last_failed', { limit: limit }).then (data) =>
      @lastFailed = data

  @