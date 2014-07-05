App.controller 'MonitorCtrl', ($scope, UserService) ->
  $scope.monitor = { interval: 10, url: 'http://', emailNotification: true, email: UserService.currentUser.email }
  $scope.intervalOptions = [
    { value: 1, text: 'minute' }
    { value: 2, text: '2 minutes'}
    { value: 5, text: '5 minutes'}
    { value: 10, text: '10 minutes'}
    { value: 15, text: '15 minutes'}
    { value: 30, text: '30 minutes'}
    { value: 60, text: 'hour'}
  ]

  $scope.phoneNumberRequired = ->
    if $scope.monitor.textNotification || $scope.monitor.callNotification && !UserService.getCurrentUser?.phone?
      true
    else
      false