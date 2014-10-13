'use strict'
angular.module('sequencingApp').controller 'BillRecordCtrl', ['$scope', 'BillRecord', 'SequencingConst', 'Modal', 'Bill', ($scope, BillRecord, SequencingConst, Modal, Bill) ->
  $scope.bill = Modal.bill
  $scope.billStatus = SequencingConst.billStatus
  BillRecord.get id: $scope.bill.id, (data)->
    if data.bill_id
      $scope.record = data
      $scope.record.data = JSON.parse(data.data)
    else
      $scope.record = {
        data: {}
      }
    null

  $scope.save = ->
    BillRecord.create {
      bill_id: $scope.bill.id
      data: JSON.stringify($scope.record.data)
    } , ->
      $scope.$close 'ok'

  $scope.payType = SequencingConst.payType

  $scope.$watch 'bill.status', (s)->
    Bill.update id: $scope.bill.id, $scope.bill
  null
]
