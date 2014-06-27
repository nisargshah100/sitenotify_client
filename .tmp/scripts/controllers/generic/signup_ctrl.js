(function() {
  App.controller('SignupCtrl', function($scope, Restangular, ErrorService, UserService, $state) {
    return $scope.signup = function(user) {
      console.log(user);
      return Restangular.all('users').post(user).then(function(data) {
        UserService.setUser(data);
        return $state.go('dashboard.home');
      }, function(response) {
        return $scope.errors = ErrorService.fullMessages(response);
      });
    };
  });

}).call(this);
