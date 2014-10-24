'use strict'

angular.module('sequencingApp').controller 'BillsCtrl', ['$scope', 'Bill', 'Order', 'SequencingConst', 'Modal', '$modal', ($scope, Bill, Order, SequencingConst, Modal, $modal) ->
  $scope.getBills = ->
    $scope.showBills = true
    $scope.showOrders = false
    Bill.query (data)->
      $scope.bills = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null
  newBill = ->
    $scope.showOrders = true
    $scope.showBills = false
    Order.query status: 'to_checkout', (data)->
      $scope.orders = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null
  $scope.orderStatus = SequencingConst.orderStatus

  $scope.checkout = ->
    if $scope.orders && $scope.orders.length
      ids = []
      angular.forEach $scope.orders, (o, i)->
        if angular.element('tr.ui-selected[i='+i+']').length
          ids.push o.id
      if ids.length
        Bill.create ids: ids, create_date: $scope.today, ->
          newBill()
    else
      newBill()

  $scope.today = SequencingConst.date2string()

  $scope.delete = (id, index)->
    Bill.delete {id: id}
    $scope.bills.splice index, 1

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

]
