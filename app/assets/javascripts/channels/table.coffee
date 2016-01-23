class @Table
  constructor: (roomToken) ->
    self = @

    @seed = Math.floor((Math.random() * 1000000));

    $ =>
      @initDragable()
      @initMenu()

    @subscription = App.table = App.cable.subscriptions.create { channel: "TableChannel", room_token: roomToken },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        if data.dragId? && data.left? && data.top? && data.seed != self.seed
          $("[data-drag-id=#{data.dragId}]").css
            opacity: 0.5
          .animate
            left: data.left
            top: data.top
            opacity: 1
          , 300

      move: (data) ->
        @perform 'move', data

  initDragable: ->
    self = @

    $('.dragable-box').draggable
      stop: (e) ->
        self.subscription.move
          dragId: $(@).data('dragId')
          left: $(@).css('left')
          top: $(@).css('top')
          seed: self.seed

  initMenu: ->
    $('.room-ui-menu').slinky()
