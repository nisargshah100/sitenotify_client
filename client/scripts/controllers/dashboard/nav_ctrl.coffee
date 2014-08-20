App.controller 'NavCtrl', ($scope, $rootScope, UserService, $state, AccountService) ->
  
  $scope.account = ->
    AccountService.current

  $scope.user = ->
    UserService.currentUser

  $scope.logout = (e) ->
    e.preventDefault()
    UserService.logout()
    $state.go('main2')

  $scope.otherAccounts = ->
    _.filter AccountService.accounts, ((a) -> a.id != AccountService.current.id)

  $scope.setNewAccount = (acc) ->
    AccountService.setCurrent(acc)
    $state.transitionTo('dashboard.home')
    $rootScope.$broadcast('new_account', acc.id)