App.config (RestangularProvider, $httpProvider) ->
  host = window.location.hostname.replace('www.', '')
  accpepted_hosts = ['sitenotify.net', 'sitenotify.dev', 'localhost']
  host = 'sitenotify.net' if not _.include(accpepted_hosts, host)

  RestangularProvider.setBaseUrl("http://server.#{host}/api")

App.run (Restangular, $state) ->
  Restangular.setErrorInterceptor (response, deferred, responseHandler) ->
    if response.status not in [422, 401, 404]
      alert 'Unable to process this request'
      return false

    if response.status == 401
      $state.go('special.login')
      return false

    if response.status == 404
      alert 'Unable to contact server. Make sure your internet connection is fine.'
      return false

    return true