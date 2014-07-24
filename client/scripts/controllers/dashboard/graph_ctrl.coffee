App.controller 'GraphResponseTimeCtrl', ($scope, MonitorService) ->
  $scope.data = []
  $scope.canvas = '#response_time_graph_placeholder'
  $scope.startDate = moment().subtract(30, 'minutes')
  $scope.endDate = moment()

  $scope.init = ->
    MonitorService.current.getList('stats/daily_checks', {
      start_date: $scope.startDate.toDate(),
      end_date: $scope.endDate.toDate()
    }).then (data) =>
      $scope.data = _.map(data, (x) -> [moment(x.done_processing_time).toDate().getTime(), x.response_time])
      $scope.draw()
  
  $scope.draw = ->
    $.plot($scope.canvas, [$scope.data], {
      series: {
        lines: {
          show: true,
          lineWidth: 1
        },
        shadowSize: 0
      },
      xaxis: {
        mode: "time",
        min: $scope.startDate.toDate().getTime(),
        max: $scope.endDate.toDate().getTime(),
        timeformat: "%H:%M %p"
      }
    });

