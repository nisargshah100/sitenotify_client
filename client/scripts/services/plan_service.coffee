App.service 'PlanService', (Restangular) ->
  @plans = []
  
  @fetchPlans = ->
    Restangular.all('plans').getList().then (data) =>
      @plans = data

  @freePlan = ->
    _.find @plans, (x) -> x.price == '0.00' 

  @