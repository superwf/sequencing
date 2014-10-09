'use strict'
angular.module('sequencingApp').controller 'OrderMailsCtrl', ['$scope', 'SequencingConst', 'OrderMail', 'Order', ($scope, SequencingConst, OrderMail, Order) ->
  $scope.getOrders = ->
    $scope.orderMails = []
    OrderMail.sending (data)->
      $scope.orders = data

  $scope.getOrderMails = ->
    $scope.orders = []
    OrderMail.query (data)->
      $scope.orderMails = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null

  $scope.expand = (order)->
    if !order.reactions
      Order.interpretedReactionFiles id: order.id, (data)->
        order.reactions = data
    else
      order.reactions = []
  $scope.interpreteCodeColor = SequencingConst.interpreteCodeColor

  $scope.send = (send)->
    if send
      angular.forEach $scope.orders, (order, i)->
        if angular.element('tr.ui-selected[i=' + i + ']').length
          OrderMail.create order_id: order.id, mail_type: 'interprete', ->
            $scope.orders.splice i, 1
    else
      angular.forEach $scope.orders, (order, i)->
        if angular.element('tr.ui-selected[i=' + i + ']').length
          OrderMail.submitInterpretedReactionFiles order_id: order.id, ->
            $scope.orders.splice i, 1
  $scope.reinterprete = ->
    angular.forEach $scope.orders, (order, i)->
      if angular.element('tr.ui-selected[i=' + i + ']').length
        Order.reinterprete order_id: order.id, ->
          $scope.orders.splice i, 1
]
