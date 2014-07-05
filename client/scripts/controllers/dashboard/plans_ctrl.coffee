App.controller 'PlansCtrl', ($scope, PlanService, AccountService) ->
  $scope.selectedPlanId = null

  $scope.setup = ->
    PlanService.fetchPlans() if PlanService.plans.length == 0

  $scope.account = ->
    AccountService.current

  $scope.plans = ->
    _.filter(PlanService.plans, (x) -> x.id != AccountService.current.plan.id)

  $scope.selectedPlan = ->
    if $scope.selectedPlanId && $scope.selectedPlanObject?.id != $scope.selectedPlanId
      $scope.selectedPlanObject = _.find($scope.plans(), (x) -> x.id == parseInt($scope.selectedPlanId))
    
    $scope.selectedPlanObject


