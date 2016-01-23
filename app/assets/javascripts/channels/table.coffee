class @Table
  constructor: (roomToken) ->
    self = @

    @seed = Math.floor((Math.random() * 1000000));

    $ =>
      @initDragable()
      @initMenu()
      @initAddingItems()

    @subscription = App.table = App.cable.subscriptions.create { channel: "TableChannel", room_token: roomToken },
      connected: ->
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        if this["received_#{data.action}"]
          this["received_#{data.action}"].call(this, data)

      received_update: (data) ->
        return if data.seed == self.seed
        $("[data-table-item-id=#{data.tableItemId}]").css
          opacity: 0.5
        .animate
          left: data.left
          top: data.top
          opacity: 1
        , 300

      received_create: (data) ->
        $newObject = $(data.html)
        self._initDraggableItem $newObject
        $('.room-table').append($newObject)

      update: (data) ->
        @perform 'update', data

      create: (data) ->
        @perform 'create', data

  initDragable: ->
    @_initDraggableItem $('.table-item')

  initMenu: ->
    $('.room-ui-menu').slinky()

  initAddingItems: ->
    self = @

    $('.room-ui-menu').on 'click', '.template-example', ->
      self.subscription.create({ template_id: $(@).data('templateId') })

  _initDraggableItem: ($obj) ->
    self = @

    $obj.draggable
      stop: (e) ->
        self.subscription.update
          tableItemId: $(@).data('tableItemId')
          left: $(@).css('left')
          top: $(@).css('top')
          seed: self.seed
