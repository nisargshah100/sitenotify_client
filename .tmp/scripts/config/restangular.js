(function() {
  App.config(function(RestangularProvider, $httpProvider) {
    return RestangularProvider.setBaseUrl('http://server.sitenotify.dev/api');
  });

  App.run(function(Restangular, $state) {
    return Restangular.setErrorInterceptor(function(response, deferred, responseHandler) {
      var _ref;
      if ((_ref = response.status) !== 422 && _ref !== 401 && _ref !== 404) {
        alert('Unable to process this request');
        return false;
      }
      if (response.status === 401) {
        $state.go('special.login');
        return false;
      }
      if (response.status === 404) {
        alert('Unable to contact server. Make sure your internet connection is fine.');
        return false;
      }
      return true;
    });
  });

}).call(this);
