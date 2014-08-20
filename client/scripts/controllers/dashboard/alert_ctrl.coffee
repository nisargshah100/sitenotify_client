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
        LoggerService.success("Removed #{alert.name}", 1000)


App.controller 'AlertFormCtrl', ($scope, MonitorService, ErrorService, $state, LoggerService, $stateParams) ->
  $scope.alert = {}
  $scope.membersInAlert = []
  $scope.loading = false
  $scope.downThreshold = 1
  $scope.slowThreshold = 2

  $scope.init = ->
    $scope.loadAlert() if $stateParams.alert_id

  $scope.loadAlert = ->
    id = parseInt($stateParams.alert_id)
    if id
      MonitorService.current.customGET("site_alerts/#{id}").then(
        (data) ->
          $scope.membersInAlert = data.users
          delete data.users
          $scope.alert = data
          $scope.downThreshold = data.threshold_down
          $scope.slowThreshold = data.threshold_slow
      )

  $scope.members = (val) ->
    exclude_ids = _.map($scope.membersInAlert, (x) -> x.id)
    MonitorService.current.customGET 'users', { q: val, exclude: exclude_ids}

  $scope.selectedMembers = ->
    $scope.membersInAlert

  $scope.save = (alert) ->
    alert ||= {}
    alert.threshold_down = $scope.downThreshold
    alert.threshold_slow = $scope.slowThreshold
    alert.users = $scope.membersInAlert

    if alert.id
      m = MonitorService.current.customPUT(alert, "site_alerts/#{alert.id}")
    else
      m = MonitorService.current.customPOST(alert, 'site_alerts')

    m.then(
      (data) ->
        $state.transitionTo('dashboard.alerts.index', { monitor_id: $scope.monitor().id })
        LoggerService.success("Alert saved", 1000)
      (err) ->
        $scope.errors = ErrorService.fullMessages(err)
    )

  $scope.monitor = ->
    MonitorService.current

  $scope.labelTypeAhead = (member) ->
    if member?
      "#{member.name} (#{member.email})"

  $scope.nameSelected = (item, model, label) ->
    if item && model && label
      $scope.selectedName = null
      $scope.membersInAlert.push(model)

  # for some reason autocomplete calls the first button when hitting enter on empty input
  $scope.blah = (user) ->

  $scope.removeUserFromList = (user) ->
    $scope.membersInAlert = _.reject($scope.membersInAlert, (x) -> x.id == user.id)