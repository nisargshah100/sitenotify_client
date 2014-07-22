App.controller 'MonitorNewCtrl', ($scope, UserService, AccountService, ErrorService, MonitorService, $state) ->
  $scope.monitor = { interval: 10, url: 'http://' }
  $scope.intervalOptions = [
    { value: 1, text: 'minute' }
    { value: 2, text: '2 minutes'}
    { value: 5, text: '5 minutes'}
    { value: 10, text: '10 minutes'}
    { value: 15, text: '15 minutes'}
    { value: 30, text: '30 minutes'}
    { value: 60, text: 'hour'}
  ]

  $scope.saveMonitor = ->
    AccountService.current.customPOST($scope.monitor, 'site_monitors').then(
      (data) ->
        MonitorService.refresh =>
          $state.transitionTo('dashboard.monitor.show', { id: data.id })
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )

App.controller 'MonitorEditCtrl', ($scope, UserService, AccountService, ErrorService, MonitorService, $state, LoggerService) ->
  $scope.monitor = angular.copy(MonitorService.current)

  $scope.intervalOptions = [
    { value: 1, text: 'minute' }
    { value: 2, text: '2 minutes'}
    { value: 5, text: '5 minutes'}
    { value: 10, text: '10 minutes'}
    { value: 15, text: '15 minutes'}
    { value: 30, text: '30 minutes'}
    { value: 60, text: 'hour'}
  ]

  $scope.saveMonitor = ->
    $scope.monitor.put($scope.monitor).then(
      (data) ->
        MonitorService.refresh =>
          $state.transitionTo('dashboard.monitor.show', { id: $scope.monitor.id })
          LoggerService.success("Monitor changed", 1000)
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )

App.controller 'MonitorStatsCtrl', ($scope, MonitorService, $interval) ->
  $scope.monitor.range = 'forever'
  $scope.startDate = moment().startOf('day')
  $scope.endDate = moment().endOf('day')

  $scope.$watch 'monitor.range', -> $scope.setRange()

  minuteInterval = $interval((() -> 
    MonitorService.getStats(MonitorService.current.id, $scope.startDate, $scope.endDate)
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(minuteInterval)

  $scope.setRange = ->
    r = $scope.monitor.range
    if r == 'daily'
      $scope.startDate = moment().startOf('day')
      $scope.endDate = moment().endOf('day')
    else if r == 'weekly'
      $scope.startDate = moment().startOf('week')
      $scope.endDate = moment().endOf('week')
    else
      $scope.startDate = null
      $scope.endDate = null

    MonitorService.getStats(MonitorService.current.id, $scope.startDate, $scope.endDate)

  $scope.stats = ->
    MonitorService.currentStats

  $scope.uptime = ->
    (parseFloat(MonitorService.currentStats.total_success_checks) / MonitorService.currentStats.total_checks * 100).toFixed(2)

App.controller 'MonitorCtrl', ($scope, MonitorService, $stateParams, $interval, $state, LoggerService) ->

  minuteInterval = $interval((() -> 
    MonitorService.refresh => MonitorService.setCurrent(parseInt($stateParams.id))
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(minuteInterval)

  $scope.$on 'new_account', (event) =>
    MonitorService.refresh =>
      MonitorService.setCurrent(parseInt($stateParams.id))

  $scope.deleteMonitor = ->
    if confirm('When a monitor is deleted, we delete all its data. We cannot recover once you delete the monitor!')
      MonitorService.current.remove().then(
        (data) ->
          MonitorService.refresh()
          LoggerService.success('The monitor has been removed')
          $state.transitionTo('dashboard.home')
        (err) ->
          LoggerService.error('We were unable to remove this monitor')
      )

  $scope.monitor = ->
    MonitorService.current

  $scope.site_status = ->
    return 'unknown' if !MonitorService.current.last_check
    s = MonitorService.current.last_check.status_success
    if s then 'up' else 'down'

App.controller 'MonitorDownOrSlowCtrl', ($scope, $interval, MonitorService) ->

  minuteInterval = $interval((() -> 
    MonitorService.getLastFailed()
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(minuteInterval)

  $scope.init = ->
    MonitorService.getLastFailed()

  $scope.checks = ->
    MonitorService.lastFailed

  $scope.done_processing_time = (check) ->
    moment(check.done_processing_time).format('MM/DD/YYYY [at] h:mm a')


App.controller 'MonitorResponseTimeChartCtrl', ($scope) ->
