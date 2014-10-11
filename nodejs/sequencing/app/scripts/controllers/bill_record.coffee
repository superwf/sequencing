'use strict'
angular.module('sequencingApp').controller 'BillRecordCtrl', ['$scope', 'BillRecord', 'SequencingConst', 'Modal', ($scope, BillRecord, SequencingConst, Modal) ->
  $scope.bill = Modal.bill
  billFlow = SequencingConst.billFlow
  $scope.record = {
    data: {}
  }
  $scope.save = ->
    BillRecord.create {
      flow: $scope.bill.status
      data: JSON.stringify($scope.record.data)
      bill_id: $scope.bill.id
    } , ->
      i = billFlow.indexOf $scope.bill.status
      nextFlow = billFlow[i+1]
      if nextFlow
        $scope.bill.status = nextFlow
  null
]
