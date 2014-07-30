App.controller 'LoginCtrl', ($scope, Restangular, UserService, $state, $stateParams, $cookies) ->
  $scope.inviteCode = $stateParams.inviteCode
  $scope.accountId = $stateParams.accountId

  $scope.login = (user) ->
    user ||= {}
    user.invite_code = $scope.inviteCode if $scope.inviteCode
    Restangular.all('sessions').post(user).then(
      (data) ->
        UserService.setUser(data)
        $cookies.currentAccountId = $scope.accountId
        loginPath = UserService.getAndResetLoginPath()
        if loginPath
          location.href = loginPath
        else
          $state.go('dashboard.home')
      (response) ->
        msg = response.data.error
        msg ||= 'Invalid email or password'
        $scope.error = msg
    )