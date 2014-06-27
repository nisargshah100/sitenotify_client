App.controller 'NavCtrl', ($scope, UserService) ->
  $scope.user = UserService.currentUser