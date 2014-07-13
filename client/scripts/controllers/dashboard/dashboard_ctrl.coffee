App.controller 'DashboardCtrl', ($scope, AccountService, UserService, $timeout) ->
  $scope.flash = {}
  
  $scope.$on 'dashboardFlashEvent', (event, type, msg, delay) ->
    delay ||= 5000
    $scope.flash.type = type
    $scope.flash.msg = msg

    $timeout((() -> $scope.flash = {}), delay)

  $scope.plan = ->
    AccountService.current.plan

  $scope.account = ->
    AccountService.current