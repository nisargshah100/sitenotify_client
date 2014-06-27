(function() {
  App.config(function($stateProvider, $urlRouterProvider) {
    $urlRouterProvider.otherwise("/not_found");
    $stateProvider.state('special', {
      templateUrl: 'views/layouts/special.html'
    }).state('special.login', {
      url: '/login',
      templateUrl: 'views/generic/login.html'
    }).state('special.signup', {
      url: '/signup',
      templateUrl: 'views/generic/signup.html'
    }).state('not_found', {
      url: '/not_found',
      templateUrl: 'views/generic/not_found.html'
    });
    $stateProvider.state('dashboard', {
      templateUrl: 'views/layouts/dashboard.html',
      resolve: {
        currentUser: function(UserService) {
          return UserService.currentUser || UserService.refresh();
        }
      }
    }).state('dashboard.home', {
      url: '/dashboard'
    });
    return $stateProvider.state('main', {
      url: ''
    }).state('main2', {
      url: '/'
    });
  });

}).call(this);
