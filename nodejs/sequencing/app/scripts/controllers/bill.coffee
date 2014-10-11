'use strict'
angular.module('sequencingApp').controller 'BillCtrl', ['$scope', 'Bill', 'SequencingConst', 'Modal', ($scope, Bill, SequencingConst, Modal) ->
  $scope.bill = Modal.record
  Bill.bill_orders bill_id: $scope.bill.id, (data)->
    $scope.bill.bill_orders = data
  $scope.save = (bill_order)->
    Bill.update_bill_order id: bill_order.id, $scope.record
  null
]
