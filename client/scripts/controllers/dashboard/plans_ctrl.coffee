App.controller 'PlansCtrl', ($scope, PlanService, AccountService, DevProdService) ->
  $scope.selected = {}
  $scope.card = {}
  $scope.months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']

  $scope.stripeKey = ->
    if DevProdService.isDev()
      'pk_test_4Lo5tMNXpP3Q2See7xLjhfww'
    else
      'pk_live_4Lo5KANizL07LU5JPW9fgYGl'

  $scope.setup = ->
    $scope.$watch 'selected.id', (n, o) ->
      $scope.selected.obj = _.find($scope.plans(), (x) -> x.id == parseInt(n))

    Stripe.setPublishableKey($scope.stripeKey())

  $scope.account = ->
    AccountService.current

  $scope.plans = ->
    _.filter(PlanService.plans, (x) -> x.id != AccountService.current.plan.id)

  $scope.changePlan = (stripeToken) ->
    

  $scope.processPaymentFinished = (status, response) ->
    if response.error
      $scope.error = response.error.message
      $scope.$digest()
    else
      $scope.changePlan(response.id)

  $scope.processPayment = (form) ->
    $scope.card.processing = true
    Stripe.card.createToken $('#payment-form'), processPaymentFinished


