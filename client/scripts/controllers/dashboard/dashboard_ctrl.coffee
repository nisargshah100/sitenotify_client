App.controller 'DashboardCtrl', ($scope, AccountService, UserService) ->
  
  $scope.plan = ->
    AccountService.current.plan

  $scope.account = ->
    AccountService.current