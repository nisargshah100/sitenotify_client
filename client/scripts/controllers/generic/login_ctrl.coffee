App.controller 'LoginCtrl', ($scope, Restangular, UserService, $state, $stateParams, $cookies) ->
  $scope.inviteCode = $stateParams.inviteCode
  $scope.accountId = $stateParams.accountId
  $scope.code = $stateParams.code
  $scope.id = $stateParams.id

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

  $scope.reset = (user) ->
    user ||= {}
    Restangular.all('users/reset_password').post(user).then(
      (data) ->
        $scope.passwordResetEmailSent = true
    )

  $scope.changePassword = (user) ->
    user ||= {}
    $scope.error = null
    if user.password != user.confirm_password
      $scope.error = 'Password must match confirm password'
      return

    if not user.password?
      $scope.error = 'Password is required'
      return

    Restangular.all('users/change_password').post({
      password: user.password, id: $scope.id, code: $scope.code
    }).then(
      (data) ->
        $state.go('special.login')
      (response) ->
        $scope.error = response.data.error || "We couldn't reset your password"
    )