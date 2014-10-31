'use strict'

angular.module('sequencingApp').controller 'BillsCtrl', ['$scope', 'Bill', 'Order', 'Sequencing', 'Modal', '$modal', 'PrepaymentRecord', 'Company', ($scope, Bill, Order, Sequencing, Modal, $modal, PrepaymentRecord, Company) ->
  $scope.$emit 'event:title', 'bill'
  Bill.query (data)->
    $scope.bills = data.records
    angular.forEach $scope.bills, (v, i)->
      PrepaymentRecord.query bill_id: v.id, all: true, (data)->
        v.prepayment_records = data
        null
      null
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    null

  $scope.delete = (id, index)->
    Bill.delete {id: id}, ->
      $scope.bills.splice index, 1

  $scope.cancelRelate = (bill, id, i)->
    PrepaymentRecord.delete id: id, ->
      bill.prepayment_records.splice i, 1
      null
    null

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/bill.html'
      controller: 'BillCtrl'
      size: 'lg'
    }

  $scope.run = (bill)->
    Modal.bill = bill
    modal = $modal.open {
      templateUrl: '/views/billRecord.html'
      controller: 'BillRecordCtrl'
      size: 'lg'
    }

  $scope.prepayment = (bill)->
    Modal.bill = bill
    modal = $modal.open {
      templateUrl: '/views/prepayments.html'
      controller: 'PrepaymentsCtrl'
      size: 'lg'
    }
    .result.then (record)->
      bill.prepayment_records.push record
      null
    null

  null
]
