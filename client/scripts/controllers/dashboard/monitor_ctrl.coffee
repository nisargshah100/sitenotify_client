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

App.controller 'MonitorCtrl', ($scope, MonitorService, $stateParams, $interval) ->

  minuteInterval = $interval((() -> 
    MonitorService.getStats(MonitorService.current.id)
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(minuteInterval)

  $scope.$on 'new_account', (event) =>
    MonitorService.refresh =>
      MonitorService.setCurrent(parseInt($stateParams.id))

  $scope.monitor = ->
    MonitorService.current

  $scope.stats = ->
    MonitorService.currentStats

  $scope.uptime = ->
    (parseFloat(MonitorService.currentStats.total_success_checks) / MonitorService.currentStats.total_checks * 100).toFixed(2)