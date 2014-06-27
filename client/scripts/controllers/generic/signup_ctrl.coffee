App.controller 'SignupCtrl', ($scope, Restangular, ErrorService, UserService, $state) ->
  $scope.signup = (user) ->
    console.log user
    Restangular.all('users').post(user).then(
      (data) ->
        UserService.setUser(data)
        $state.go('dashboard.home')

      (response) ->
        $scope.errors = ErrorService.fullMessages(response)
    )