App.controller 'SignupCtrl', ($scope, Restangular, ErrorService, UserService, $state, $stateParams, $cookies) ->
  $scope.inviteCode = $stateParams.inviteCode
  $scope.accountId = $stateParams.accountId

  $scope.signup = (user) ->
    user ||= {}
    if $scope.inviteCode
      user.invite_code = $scope.inviteCode
      user.account_name = "#{user.email}'s Account"

    Restangular.all('users').post(user).then(
      (data) ->
        UserService.setUser(data)
        $cookies.currentAccountId = $scope.accountId
        $state.go('dashboard.home')

      (response) ->
        $scope.errors = ErrorService.fullMessages(response)
    )