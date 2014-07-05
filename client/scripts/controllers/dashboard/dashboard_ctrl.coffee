App.controller 'DashboardCtrl', ($scope, AccountService) ->
  
  $scope.plan = ->
    AccountService.current.plan

  $scope.account = ->
    AccountService.current