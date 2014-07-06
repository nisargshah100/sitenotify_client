App.controller 'PlansCtrl', ($scope, PlanService, AccountService) ->
  $scope.selected = {}

  $scope.setup = ->
    $scope.$watch 'selected.id', (n, o) ->
      $scope.selected.obj = _.find($scope.plans(), (x) -> x.id == parseInt(n))

  $scope.account = ->
    AccountService.current

  $scope.plans = ->
    _.filter(PlanService.plans, (x) -> x.id != AccountService.current.plan.id)

