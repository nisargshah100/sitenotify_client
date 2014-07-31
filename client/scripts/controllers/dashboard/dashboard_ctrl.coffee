App.controller 'DashboardCtrl', ($scope, AccountService, UserService, MonitorService, $timeout, $state, $interval) ->
  $scope.flash = {}
  $scope.flashTimeout = null
  $scope.monitorsFilter = {}

  $scope.$on 'dashboardFlashEvent', (event, type, msg, delay) ->
    $timeout.cancel($scope.flashTimeout)
    $scope.flash = {}
    delay ||= 5000

    $scope.$apply ->
      $scope.flash.type = type
      $scope.flash.msg = msg

    $scope.flashTimeout = $timeout((() -> $scope.flash = {}), delay)

  $scope.$on 'new_account', =>
    MonitorService.refresh()

  monitorInterval = $interval((() -> 
    MonitorService.refresh()
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(monitorInterval)

  $scope.plan = ->
    AccountService.current.plan

  $scope.account = ->
    AccountService.current

  $scope.monitors = ->
    MonitorService.monitors

  $scope.goToMonitor = (monitor) ->
    $state.transitionTo('dashboard.monitor.show', { id: monitor.id })

  $scope.monitorStatusImage = (monitor) ->
    if monitor.last_check
      if monitor.last_check.status_success then 'check.png' else 'error.png'
    else
      'dash.png'