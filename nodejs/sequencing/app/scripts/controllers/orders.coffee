'use strict'

angular.module('sequencingApp').controller 'OrdersCtrl', ['$scope', 'Order', 'Modal', '$modal', ($scope, Order, Modal, $modal) ->
  Order.query (data) ->
    $scope.records = data.records
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    return
 
  $scope.delete = (id, index)->
    Order.delete {id: id}
    $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/order.html'
      controller: 'VectorCtrl'
    }
]
