App.service 'PlanService', (Restangular) ->
  @plans = []
  
  @fetchPlans = ->
    Restangular.all('plans').getList().then (data) =>
      @plans = data

  @