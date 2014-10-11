'use strict'
angular.module('sequencingApp').controller 'BillCtrl', ['$scope', 'Bill', 'SequencingConst', 'Modal', ($scope, Bill, SequencingConst, Modal) ->
  $scope.bill = Modal.record
  Bill.bill_orders bill_id: $scope.bill.id, (data)->
    $scope.bill.bill_orders = data
  $scope.save = (bo)->
    Bill.update_bill_order bo
    bo.moeny = bo.price * bo.charge_count + other_money

  $scope.delete = (bo, index)->
    Bill.delete_bill_order {id: bo.id}
    $scope.bill.bill_orders.splice index, 1

  null
]
