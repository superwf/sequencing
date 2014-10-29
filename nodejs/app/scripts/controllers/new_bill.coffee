'use strict'
angular.module('sequencingApp').controller 'NewBillCtrl', ['$scope', 'Bill', 'Order', 'SequencingConst', 'Modal', '$modal', ($scope, Bill, Order, SequencingConst, Modal, $modal) ->
  newBill = ->
    $scope.showOrders = true
    $scope.showBills = false
    Order.query status: 'to_checkout', (data)->
      $scope.orders = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      null
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
  null

]
