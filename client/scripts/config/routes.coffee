App.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.otherwise("/not_found");

  $stateProvider
    .state 'special', {
      templateUrl: 'views/layouts/special.html'
    }
    
    .state 'special.login', {
      url: '/login?inviteCode&accountId'
      templateUrl: 'views/generic/login.html'
    }

    .state 'special.signup', {
      url: '/signup?inviteCode&accountId',
      templateUrl: 'views/generic/signup.html'
    }

    .state 'not_found', {
      url: '/not_found'
      templateUrl: 'views/generic/not_found.html'
    }

  $stateProvider
    .state 'dashboard', {
      templateUrl: 'views/layouts/dashboard.html'
      resolve: {
        currentUser: (UserService) ->
          UserService.currentUser || UserService.refresh()
        accounts: (AccountService) ->
          AccountService.refresh()
      }
    }

    .state 'dashboard.home', {
      url: '/dashboard'
      templateUrl: 'views/dashboard/home.html'
    }

    .state 'dashboard.monitor', {
      template: '<div ui-view></div>'
    }

    .state 'dashboard.monitor.new', {
      url: '/dashboard/monitor/new'
      templateUrl: 'views/dashboard/monitor/new.html'
    }

    .state 'dashboard.settings', {
      url: '/dashboard/settings'
      templateUrl: 'views/dashboard/settings.html'
    }

  $stateProvider
    .state 'main', {
      url: ''
    }
    .state 'main2', {
      url: '/'
    }