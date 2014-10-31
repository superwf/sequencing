'use strict'
angular.module('sequencingApp').controller 'OrderEmailsCtrl', ['$scope', 'Sequencing', 'Email', 'Order', ($scope, Sequencing, Email, Order) ->
  $scope.getOrders = ->
    Email.sending (data)->
      $scope.orders = data

  $scope.expand = (order)->
    order.reactions ||= []
    if !order.reactions.length
      Order.interpretedReactionFiles id: order.id, (data)->
        order.reactions = data
    else
      order.reactions = []
  $scope.interpreteCodeColor = Sequencing.interpreteCodeColor

  $scope.send = (send)->
    if send
      angular.forEach $scope.orders, (order, i)->
        if angular.element('tr.ui-selected[i=' + i + ']').length
          Email.create order_id: order.id, mail_type: 'interprete', ->
            $scope.orders.splice i, 1
    else
      angular.forEach $scope.orders, (order, i)->
        if angular.element('tr.ui-selected[i=' + i + ']').length
          Order.submitInterpretedReactionFiles id: order.id, ->
            $scope.orders.splice i, 1
  $scope.reinterprete = ->
    angular.forEach $scope.orders, (order, i)->
      if angular.element('tr.ui-selected[i=' + i + ']').length
        Order.reinterprete id: order.id, ->
          $scope.orders.splice i, 1
]
