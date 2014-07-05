App.controller 'PlansCtrl', ($scope, PlanService, AccountService) ->
  
  $scope.setup = ->
    PlanService.fetchPlans() if PlanService.plans.length == 0

  $scope.plans = ->
    _.filter(PlanService.plans, (x) -> x.id != AccountService.current.plan.id)