App.controller 'GraphResponseTimeCtrl', ($scope, MonitorService) ->
  $scope.data = []
  $scope.canvas = '#response_time_graph_placeholder'

  $scope.init = ->
    MonitorService.current.getList('stats/daily_checks').then (data) =>
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
        min: moment().subtract(1, 'day').toDate().getTime(),
        max: moment().toDate().getTime(),
        timeformat: "%H:%M %p"
      }
    });

