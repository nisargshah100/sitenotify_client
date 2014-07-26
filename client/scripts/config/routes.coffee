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
        accounts: (currentUser, AccountService) ->
          AccountService.refresh()
        monitors: (accounts, MonitorService) ->
          MonitorService.refresh()
      }
    }

    .state 'dashboard.home', {
      url: '/dashboard'
      templateUrl: 'views/dashboard/home.html'
    }

    .state 'dashboard.monitor', {
      template: '<div ui-view></div>'
    }

    .state 'dashboard.alerts', {
      template: '<div ui-view></div>'
    }

    .state 'dashboard.monitor.new', {
      url: '/dashboard/monitors/new'
      templateUrl: 'views/dashboard/monitor/new.html'
    }

    .state 'dashboard.monitor.edit', {
      url: '/dashboard/monitors/:id/edit'
      templateUrl: 'views/dashboard/monitor/edit.html'
      onEnter: (MonitorService, $stateParams) ->
        MonitorService.setCurrent(parseInt($stateParams.id))
    }

    .state 'dashboard.monitor.show', {
      url: '/dashboard/monitors/:id'
      templateUrl: 'views/dashboard/monitor/show.html'
      onEnter: (MonitorService, $stateParams) ->
        MonitorService.currentStats = null
        MonitorService.setCurrent(parseInt($stateParams.id))
    }

    .state 'dashboard.settings', {
      url: '/dashboard/settings'
      templateUrl: 'views/dashboard/settings.html'
    }

    .state 'dashboard.alerts.index', {
      url: '/dashboard/alerts',
      templateUrl: 'views/dashboard/alerts/index.html'
    }

    .state 'dashboard.plan', {
      url: '/dashboard/plan'
      templateUrl: 'views/dashboard/plan.html'
      resolve: {
        plans: (currentUser, PlanService) ->
          if PlanService.plans.length == 0
            PlanService.fetchPlans()
        cards: (accounts, CreditCardService) ->
          CreditCardService.refresh()
      }
    }

  $stateProvider
    .state 'main', {
      url: ''
      template: 'Welcome!!'
    }
    .state 'main2', {
      url: '/'
    }