'use strict'

angular.module('sequencingApp').controller 'ReworkOrderCtrl', ['$scope', 'Reaction', 'Modal', '$modal', 'Sequencing', 'BoardHead', 'Order', ($scope, Reaction, Modal, $modal, Sequencing, BoardHead, Order) ->
  $scope.$emit 'event:title', 'new_rework_order'

  $scope.searcher = {}

  $scope.order = {}
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.board_heads = data
  BoardHead.all {all: true, board_type: 'sample', is_redo: true, available: 1}, (data)->
    $scope.redo_heads = data

  $scope.config = Sequencing
  $scope.search = ->
    Reaction.reworking $scope.searcher, (data) ->
      $scope.records = data || []
      for i, v of $scope.records
        if v.board_head_id
          $scope.records[i].board_head = Sequencing.boardHeads[v.board_head_id]
        if v.precheck_code_id
          $scope.records[i].precheck_code = Sequencing.precheckCodes[v.precheck_code_id]
        if v.interprete_code_id
          $scope.records[i].interprete_code = Sequencing.interpreteCodes[v.interprete_code_id]
        if v.interpreter_id
          $scope.records[i].interpreter = Sequencing.users[v.interpreter_id]
      null

  $scope.submit = ->
    ids = []
    if $scope.order.board_head
      angular.forEach $scope.records, (v, i)->
        if angular.element('tr.ui-selected[i='+i+']').length
          ids.push v.id
      Order.generateRedo {board_head_id: $scope.order.board_head.id}, ids
    null
 
  null
]
