'use strict'
angular.module('sequencingApp').controller 'PrepaymentsCtrl', ['$scope', 'Prepayment', 'Modal', '$modal', 'Company', 'PrepaymentRecord', ($scope, Prepayment, Modal, $modal, Company, PrepaymentRecord) ->
  $scope.$emit 'event:title', 'prepayment'
  $scope.inModal = !!$scope.$close
  $scope.searcher = {}
  if $scope.inModal
    $scope.record = {}
    $scope.searcher.balance_from = 0
    $scope.createPrepaymentRecord = (p)->
      if $scope.record.money
        PrepaymentRecord.create {
          money: $scope.record.money * 1
          remark: $scope.record.remark
          bill_id: Modal.bill.id
          prepayment_id: p.id
        }, (data)->
          $scope.$close data

  Prepayment.query $scope.searcher, (data) ->
    $scope.records = data.records || []
    if $scope.records.length
      angular.forEach $scope.records, (v, i)->
        Company.get id: v.company_id, (data)->
          v.company = data
          null
        PrepaymentRecord.query prepayment_id: v.id, all: true, (data)->
          v.prepayment_records = data
          null
        null
    $scope.totalItems = data.totalItems
    $scope.perPage = data.perPage
    null
 
  $scope.delete = (id, index)->
    Prepayment.delete {id: id}, ->
      $scope.records.splice index, 1
      null
    null

  $scope.create = ->
    $modal.open {
      templateUrl: '/views/prepayment.html'
      controller: 'PrepaymentCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record
      null
    null

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/prepayment.html'
      controller: 'PrepaymentCtrl'
    }
    null

  null
]
