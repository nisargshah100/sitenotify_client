(function() {
  App.controller('LoginCtrl', function($scope, Restangular, UserService, $state) {
    return $scope.login = function(user) {
      return Restangular.all('sessions').post(user).then(function(data) {
        UserService.setUser(data.user);
        return $state.go('dashboard.home');
      }, function(response) {
        return $scope.error = 'Invalid email or password';
      });
    };
  });

}).call(this);
