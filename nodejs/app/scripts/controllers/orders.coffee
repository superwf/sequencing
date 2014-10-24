'use strict'

angular.module('sequencingApp').controller 'OrdersCtrl', ['$scope', 'Order', 'Modal', '$modal', 'SequencingConst', 'BoardHead', ($scope, Order, Modal, $modal, SequencingConst, BoardHead) ->
  $scope.searcher = {}
  $scope.s = {}
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.board_heads = data
  $scope.$watch 's.board_head', ->
    if $scope.s.board_head
      $scope.searcher.board_head_id = $scope.s.board_head.id
  $scope.search = ->
    Order.query $scope.searcher, (data) ->
      $scope.records = data.records
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    Order.delete {id: id}
    $scope.records.splice index, 1

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/order.html'
      controller: 'OrderCtrl'
      size: 'lg'
    }
  $scope.orderStatus = SequencingConst.orderStatus
]
