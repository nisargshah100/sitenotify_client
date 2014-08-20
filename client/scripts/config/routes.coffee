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

    .state 'special.forgot_password', {
      url: '/forgot_password?inviteCode&accountId',
      templateUrl: 'views/generic/forgot_password.html'
    }

    .state 'special.forgot_password_change', {
      url: '/forgot_password_change?code&id',
      templateUrl: 'views/generic/forgot_password_change.html'
    }

    .state 'not_found', {
      url: '/not_found'
      templateUrl: 'views/generic/not_found.html'
    }

  $stateProvider
    .state 'dashboard', {
      templateUrl: 'views/layouts/dashboard.html'
      resolve: {
        cookie: (UserService) ->
          UserService.initToken()
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

    .state 'dashboard.profile', {
      url: '/dashboard/profile',
      templateUrl: 'views/dashboard/profile.html'
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
      onEnter: (MonitorService, $stateParams, $state) ->
        MonitorService.currentStats = null
        MonitorService.setCurrent(parseInt($stateParams.id))
        $state.transitionTo('dashboard.home') if not MonitorService.current?
    }

    .state 'dashboard.monitor.check', {
      url: '/dashboard/monitors/:monitor_id/check/:id'
      templateUrl: 'views/dashboard/monitor/check.html'
      onEnter: ($stateParams, MonitorService) ->
        MonitorService.setCurrent(parseInt($stateParams.monitor_id))
    }

    .state 'dashboard.settings', {
      url: '/dashboard/settings'
      templateUrl: 'views/dashboard/settings.html'
    }

    .state 'dashboard.alerts.new', {
      url: '/dashboard/alerts/:monitor_id/new',
      templateUrl: 'views/dashboard/alerts/new.html'
      onEnter: ($stateParams, MonitorService) ->
        MonitorService.setCurrent(parseInt($stateParams.monitor_id))
    }

    .state 'dashboard.alerts.edit', {
      url: '/dashboard/alerts/:monitor_id/edit/:alert_id',
      templateUrl: 'views/dashboard/alerts/new.html'
      onEnter: ($stateParams, MonitorService) ->
        MonitorService.setCurrent(parseInt($stateParams.monitor_id))
    }

    .state 'dashboard.alerts.index', {
      url: '/dashboard/alerts/:monitor_id',
      templateUrl: 'views/dashboard/alerts/index.html'
      onEnter: ($stateParams, MonitorService, $state) ->
        MonitorService.setCurrent(parseInt($stateParams.monitor_id))
        $state.transitionTo('dashboard.home') if not MonitorService.current?
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