App.controller 'AlertCtrl', ($scope, MonitorService, $state, LoggerService) ->
  $scope.alerts = null

  $scope.monitor = ->
    MonitorService.current

  $scope.init = ->
    $scope.refresh()

  $scope.refresh = ->
    MonitorService.current.all('site_alerts').getList().then(
      (data) =>
        $scope.alerts = data
    )

  $scope.boolToYesNo = (b) ->
    if b then 'Yes' else 'No'

  $scope.edit = (alert) ->
    $state.transitionTo('dashboard.alerts.edit', { monitor_id: $scope.monitor().id, alert_id: alert.id })

  $scope.delete = (alert) ->
    if confirm("Are you sure you want to remove this alert?")
      alert.remove().then (data) -> 
        $scope.refresh()
        MonitorService.refresh()
        LoggerService.success("Removed #{alert.name}", 1000)


App.controller 'AlertFormCtrl', ($scope, MonitorService, ErrorService, $state, UserService, LoggerService, $stateParams) ->
  $scope.alert = {}
  $scope.membersInAlert = []
  $scope.loading = false
  $scope.thresholds = { down: 1, slow: 3 }
  $scope.loadingAlert = false
  $scope.savingAlert = false
  $scope.selected = {} 

  $scope.init = ->
    $scope.loadAlert()

  $scope.loadAlert = ->
    id = parseInt($stateParams.alert_id)
    if id
      $scope.loadingAlert = true
      MonitorService.current.customGET("site_alerts/#{id}").then(
        (data) ->
          $scope.membersInAlert = data.users
          delete data.users
          $scope.alert = data
          $scope.thresholds.down = data.threshold_down
          $scope.thresholds.slow = data.threshold_slow
          $scope.loadingAlert = false
        (err) ->
          $state.transitionTo('dashboard.alerts.index', { monitor_id: $scope.monitor().id })
          LoggerService.error('Unable to load alert', 2000)
          $scope.loadingAlert = false
      )
    else
      $scope.membersInAlert.push({ 
        id: UserService.currentUser.id
        name: UserService.currentUser.name
        has_phone: UserService.currentUser.phone?
        has_email: true
      })

  $scope.members = (val) ->
    exclude_ids = _.map($scope.membersInAlert, (x) -> x.id)
    MonitorService.current.customPOST { q: val, exclude: exclude_ids}, 'users'

  $scope.selectedMembers = ->
    $scope.membersInAlert

  $scope.save = (alert) ->
    alert ||= {}
    alert.threshold_down = $scope.thresholds.down
    alert.threshold_slow = $scope.thresholds.slow
    alert.users = $scope.membersInAlert
    $scope.savingAlert = true

    if alert.id
      m = MonitorService.current.customPUT(alert, "site_alerts/#{alert.id}")
    else
      m = MonitorService.current.customPOST(alert, 'site_alerts')

    m.then(
      (data) ->
        $state.transitionTo('dashboard.alerts.index', { monitor_id: $scope.monitor().id })
        MonitorService.refresh()
        LoggerService.success("Alert saved", 1000)
        $scope.savingAlert = false
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
        $scope.savingAlert = false
    )

  $scope.monitor = ->
    MonitorService.current

  $scope.labelTypeAhead = (member) ->
    if member?
      "#{member.name} (#{member.email})"

  $scope.nameSelected = (item, model, label) ->
    if item && model && label
      $scope.selected.name = null
      $scope.membersInAlert.push(model)

  # for some reason autocomplete calls the first button when hitting enter on empty input
  $scope.blah = (user) ->

  $scope.removeUserFromList = (user) ->
    $scope.membersInAlert = _.reject($scope.membersInAlert, (x) -> x.id == user.id)