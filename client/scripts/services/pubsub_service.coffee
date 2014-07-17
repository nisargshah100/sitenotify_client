App.service 'PubsubService', ($injector) ->

  @setup = (acc) ->
    pubnub = PUBNUB.init(
      publish_key   : 'pub-c-5df83876-9701-4ef0-9222-a9eefbf4088a',
      subscribe_key : 'sub-c-6edb63e6-0a3a-11e4-8738-02ee2ddab7fe'
    )

    pubnub.subscribe({
      channel: acc.token
      callback: => @handle(arguments[0])
    })

  @handle = (data) ->
    @mapping[data.key]()

  # now for the methods to handle events

  @account_updated = ->
    $injector.get('AccountService').refresh()
    $injector.get('MonitorService').refresh()
  
  @card_updated = ->
    $injector.get('CreditCardService').refresh()

  @members_updated = ->
    $injector.get('AccountService').fetchMembers()

  # mapping
  
  @mapping = {
    'account_updated': @account_updated,
    'card_updated': @card_updated,
    'members_updated': @members_updated
  }

  @