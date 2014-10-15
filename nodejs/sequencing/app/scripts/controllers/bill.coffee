'use strict'
angular.module('sequencingApp').controller 'BillCtrl', ['$scope', 'Bill', 'SequencingConst', 'Modal', '$modal', 'Order', ($scope, Bill, SequencingConst, Modal, $modal, Order) ->
  $scope.bill = Modal.record
  Bill.bill_orders bill_id: $scope.bill.id, (data)->
    $scope.bill.bill_orders = data
  $scope.save = (bo)->
    Bill.update_bill_order bo
    bo.moeny = bo.price * bo.charge_count + other_money

  $scope.delete = (bo, index)->
    Bill.delete_bill_order {id: bo.id}
    $scope.bill.bill_orders.splice index, 1

  $scope.showOrder = (bo)->
    Order.get id: bo.id, (data)->
      Modal.order = data
      $modal.open {
        templateUrl: '/views/orderReactions.html'
        controller: 'OrderReactionsCtrl'
        size: 'lg'
      }

  null
]
