App.controller 'ProfileCtrl', ($scope, UserService, ErrorService) ->
  $scope.user = angular.copy(UserService.currentUser)

  $scope.update = (user) ->
    $scope.user.patch($scope.user).then(
      (data) ->
        UserService.refresh()
        $scope.errors = null
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )