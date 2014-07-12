App.service 'CreditCardService', (AccountService, Restangular) ->
  @cards = []
  
  @refresh = ->
    AccountService.current.getList('credit_cards').then (data) =>
      @cards = data

  @