App.controller 'LoginCtrl', ($scope, Restangular, UserService, $state) ->
  $scope.login = (user) ->
    Restangular.all('sessions').post(user).then(
      (data) ->
        UserService.setUser(data.user)
        $state.go('dashboard.home')
      (response) ->
        $scope.error = 'Invalid email or password'
    )