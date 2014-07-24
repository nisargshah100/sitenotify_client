App.controller 'GraphResponseTimeCtrl', ($scope, MonitorService) ->
  $scope.data = []
  $scope.canvas = '#response_time_graph_placeholder'
  $scope.rangeDiffMinutes = 30

  minuteInterval = $interval((() -> 
    $scope.init()
  ), 60000)

  $scope.$on "$destroy", ->
    $interval.cancel(minuteInterval)

  $scope.setRanges = ->
    $scope.startDate = moment().subtract($scope.rangeDiffMinutes, 'minutes')
    $scope.endDate = moment()

  $scope.init = ->
    $scope.setRanges()

    MonitorService.current.getList('stats/daily_checks', {
      start_date: $scope.startDate.toDate(),
      end_date: $scope.endDate.toDate()
    }).then (data) =>
      $scope.data = _.map(data, (x) -> [moment(x.done_processing_time).toDate().getTime(), x.response_time])
      $scope.draw()
  
  $scope.draw = ->
    $.plot($scope.canvas, [$scope.data], {
      series: {
        lines: { show: true },
        points: { show: true }
      },
      grid: { hoverable: true, clickable: true },
      xaxis: {
        mode: "time",
        min: $scope.startDate.toDate().getTime(),
        max: $scope.endDate.toDate().getTime(),
        timeformat: "%H:%M"
      }
    });

