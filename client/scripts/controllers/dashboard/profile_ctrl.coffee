App.controller 'ProfileCtrl', ($scope, UserService, ErrorService, LoggerService) ->
  $scope.user = angular.copy(UserService.currentUser)

  $scope.update = (user) ->
    $scope.user.patch($scope.user).then(
      (data) ->
        UserService.refresh => $scope.user = UserService.currentUser
        $scope.errors = null
        LoggerService.success("Updated Profile", 1000)
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )