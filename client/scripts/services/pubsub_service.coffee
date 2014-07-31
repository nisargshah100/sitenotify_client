App.service 'PubsubService', ($injector, $rootScope) ->

  @setup = (acc) ->
    pubnub = PUBNUB.init(
      publish_key   : 'pub-c-5df83876-9701-4ef0-9222-a9eefbf4088a',
      subscribe_key : 'sub-c-6edb63e6-0a3a-11e4-8738-02ee2ddab7fe'
    )

    token = $injector.get('UserService').getToken()

    pubnub.subscribe({
      channel: [acc.token, token]
      callback: => @handle(arguments[0])
    })

  @handle = (data) ->
    @mapping[data.key](data) if @mapping[data.key]

  # now for the methods to handle events

  @account_updated = ->
    $injector.get('AccountService').refresh()
    $injector.get('MonitorService').refresh()
  
  @card_updated = ->
    $injector.get('CreditCardService').refresh()

  @members_updated = ->
    $injector.get('AccountService').fetchMembers()

  @card_add_failed = (data) ->
    logger = $injector.get('LoggerService')
    logger.error("The plan couldn't be changed. #{data.message}", 10000)

  # mapping
  
  @mapping = {
    'account_updated': @account_updated,
    'card_updated': @card_updated,
    'members_updated': @members_updated,
    'card_add_failed': @card_add_failed
  }

  @