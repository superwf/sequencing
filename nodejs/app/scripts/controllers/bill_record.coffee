'use strict'
angular.module('sequencingApp').controller 'BillRecordCtrl', ['$scope', 'BillRecord', 'Sequencing', 'Modal', 'Bill', ($scope, BillRecord, Sequencing, Modal, Bill) ->
  $scope.bill = Modal.bill
  $scope.billStatus = Sequencing.billStatus
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
      $scope.bill.invoice = $scope.record.data.invoice_sn
      Bill.update id: $scope.bill.id, $scope.bill
      $scope.$close 'ok'

  $scope.payType = Sequencing.payType

  $scope.$watch 'bill.status', (s)->
    Bill.update id: $scope.bill.id, $scope.bill
  null
]
