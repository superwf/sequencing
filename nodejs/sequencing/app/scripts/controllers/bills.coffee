'use strict'

angular.module('sequencingApp').controller 'BillsCtrl', ['$scope', 'Bill', 'Order', 'SequencingConst', ($scope, Bill, Order, SequencingConst) ->
  $scope.getBills = ->
    $scope.showBills = true
    $scope.showOrders = false
    if !$scope.bills
      Bill.query (data)->
        $scope.bills = data.records
        $scope.totalItems = data.totalItems
        $scope.perPage = data.perPage
        null
  $scope.newBill = ->
    $scope.showOrders = true
    $scope.showBills = false
    if !$scope.orders
      Order.query status: 'to_checkout', (data)->
        $scope.orders = data.records
        $scope.totalItems = data.totalItems
        $scope.perPage = data.perPage
        null
  $scope.orderStatus = SequencingConst.orderStatus

  $scope.checkout = ->
    ids = []
    angular.forEach $scope.orders, (o, i)->
      if angular.element('tr.ui-selected[i='+i+']').length
        ids.push o.id
    if ids.length
      Bill.create ids: ids, create_date: $scope.today

  $scope.today = SequencingConst.date2string()
]
