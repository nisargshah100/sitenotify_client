App.controller 'GraphResponseTimeCtrl', ($scope, MonitorService) ->
  $scope.data = []
  $scope.canvas = '[name=response_time_graph_placeholder]'

  $scope.init = ->
    MonitorService.current.getList('stats/daily_checks').then (data) =>
      $scope.data = _.map(data, (x) -> [moment(x.done_processing_time).toDate(), x.response_time])
      console.log $scope.data
      $scope.draw()
  
  $scope.draw = ->
    $($scope.canvas).highcharts({ 
      chart: {
        type: 'spline',
        zoomType: 'x'
      },
      title: 'Response Time',
      xAxis: {
        type: 'datetime',
        title: { text: 'Time' },
        tickInterval: 3600 * 1000
      },
      yAxis: {
        title: {
          text: 'Response Time (ms)',
          min: 0
        }
      },
      series: [{
        data: $scope.data
      }]
    })

