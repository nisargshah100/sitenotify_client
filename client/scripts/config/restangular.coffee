App.run (Restangular, $state, DevProdService, LoggerService) ->
  Restangular.setBaseUrl("http://server.#{DevProdService.host()}/api")
  
  Restangular.setErrorInterceptor (response, deferred, responseHandler) ->
    if response.status not in [422, 401, 404]
      LoggerService.error('Unable to process this request')
      return false

    if response.status == 401
      $state.go('special.login')
      return false

    if response.status == 404
      LoggerService.error("Unable to contact server. Make sure your internet connection is fine", 3000)
      return false

    return true