(function() {
  App.controller('NavCtrl', function($scope, UserService) {
    return $scope.user = UserService.currentUser;
  });

}).call(this);
