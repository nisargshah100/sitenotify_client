(function() {
  App.service('UserService', function(Restangular) {
    this.currentUser = null;
    this.setUser = function(currentUser) {
      this.currentUser = currentUser != null ? currentUser : user;
    };
    this.refresh = function() {
      return Restangular.all('users').customGET('details').then((function(_this) {
        return function(data) {
          return _this.currentUser = data.user;
        };
      })(this));
    };
    return this;
  });

}).call(this);
