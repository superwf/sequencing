'use strict'
angular.module('sequencingApp').controller 'OrderReactionsCtrl', ['$scope', 'Order', 'SequencingConst', 'Modal', '$modal', 'Client', ($scope, Order, SequencingConst, Modal, $modal, Client) ->
  $scope.order = Modal.order
  Client.get id: $scope.order.client_id, (c)->
    $scope.order.client = c
  Order.reactions {id: $scope.order.id, all: true}, (data)->
    $scope.reactions = data
    for i, v of data
      if SequencingConst.interpreteCodes[v.code_id]
        $scope.reactions[i].interprete_code = SequencingConst.interpreteCodes[v.code_id]
    null

  null
]
