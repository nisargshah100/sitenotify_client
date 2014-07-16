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
        MonitorService.refresh()
        $state.transitionTo('dashboard.monitor.show', { id: data.id })
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )

App.controller 'MonitorCtrl', ($scope, MonitorService) ->
  $scope.monitor = ->
    MonitorService.current