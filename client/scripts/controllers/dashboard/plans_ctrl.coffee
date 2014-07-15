App.controller 'PlansCtrl', ($scope, PlanService, AccountService, DevProdService, Restangular, ErrorService, $state, CreditCardService, $rootScope, $timeout) ->
  $scope.selected = {}
  $scope.card = {}
  $scope.months = ['01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12']
  $scope.selected.addNewCardView = true

  $scope.stripeKey = ->
    if DevProdService.isDev()
      'pk_test_4Lo5tMNXpP3Q2See7xLjhfww'
    else
      'pk_live_4Lo5KANizL07LU5JPW9fgYGl'

  $scope.setup = ->
    $scope.$watch 'selected.id', (n, o) ->
      $scope.selected.obj = _.find($scope.plans(), (x) -> x.id == parseInt(n))

    Stripe.setPublishableKey($scope.stripeKey())
    $scope.selected.id = _.first($scope.plans()).id
    $scope.selected.card_id = AccountService.current.default_card_id || _.first($scope.plans()).id

    $scope.selected.addNewCardView = false if $scope.cards().length > 0

  $scope.isFreeSelected = ->
    parseInt($scope.selected.id) == parseInt(PlanService.freePlan().id)

  $scope.isPlanCheaper = ->
    $scope.selected.obj.price_in_cents < AccountService.current.plan.price_in_cents

  $scope.account = ->
    AccountService.current

  $scope.plans = ->
    _.filter(PlanService.plans, (x) -> x.id != AccountService.current.plan.id)

  $scope.cards = ->
    CreditCardService.cards

  $scope.addCard = (stripeToken) ->
    AccountService.current.customPOST({ stripe_token: stripeToken, card_holder_name: $scope.card.name }, 'credit_cards').then(
      (data) ->
        $scope.changePlan(data.id)
      (err) ->
        $scope.error = ErrorService.fullMessages(err).join('. ')
        $scope.card.processing = false
    )

  $scope.changePlan = (card_id) ->
    AccountService.current.customPOST({ plan_id: $scope.selected.obj.id, card_id: card_id }, 'charges').then(
      (data) ->
        $timeout -> $rootScope.$broadcast('dashboardFlashEvent', 'success', 'Your plan has been changed. Once processing is done, your account details will update to reflect the new plan.')
        $state.transitionTo('dashboard.home')
        $scope.card.processing = false
      (err) ->
        $scope.planError = ErrorService.fullMessages(err).join('. ')
        $scope.card.processing = false
    )

  $scope.processPaymentFinished = (status, response) =>
    if response.error
      $scope.error = response.error.message
      $scope.card.processing = false
    else
      $scope.error = null
      $scope.addCard(response.id)
    $scope.$digest()

  $scope.processPayment = (form) ->
    $scope.card.processing = true
    if $scope.selected.addNewCardView
      Stripe.card.createToken $('#payment-form'), $scope.processPaymentFinished
    else
      card_id = $scope.selected.card_id
      card_id = null if $scope.isFreeSelected()
      $scope.changePlan(card_id)

