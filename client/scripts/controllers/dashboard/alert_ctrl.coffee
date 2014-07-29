App.controller 'AlertCtrl', ($scope, MonitorService) ->
  
  $scope.monitor = ->
    MonitorService.current