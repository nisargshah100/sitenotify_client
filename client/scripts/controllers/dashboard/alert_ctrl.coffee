App.controller 'AlertCtrl', ($scope, MonitorService) ->
  $scope.membersInAlert = []
  $scope.loading = false;
  $scope.downThreshold = 1
  $scope.slowThreshold = 2

  $scope.members = (val) ->
    exclude_ids = _.map($scope.membersInAlert, (x) -> x.id)
    MonitorService.current.customGET 'users', { q: val, exclude: exclude_ids}

  $scope.selectedMembers = ->
    $scope.membersInAlert

  $scope.monitor = ->
    MonitorService.current

  $scope.add = (alert) ->

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
    console.log 'hit with: ', user
    $scope.membersInAlert = _.reject($scope.membersInAlert, (x) -> x.id == user.id)

