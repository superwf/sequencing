'use strict'
angular.module('sequencingApp').controller 'OrderReactionsCtrl', ['$scope', 'Order', 'Sequencing', 'Modal', '$modal', 'Client', ($scope, Order, Sequencing, Modal, $modal, Client) ->
  $scope.order = Modal.order
  if !$scope.order.client
    Client.get id: $scope.order.client_id, (c)->
      $scope.order.client = c
  Order.reactions {id: $scope.order.id, all: true}, (data)->
    $scope.reactions = data
    for i, v of data
      if Sequencing.interpreteCodes[v.code_id]
        $scope.reactions[i].interprete_code = Sequencing.interpreteCodes[v.code_id]
    null

  null
]
