'use strict'

angular.module('sequencingApp').controller 'BoardCtrl', ['$scope', 'Board', 'SequencingConst', '$routeParams', 'Modal', 'BoardHead', ($scope, Board, SequencingConst, $routeParams, Modal, BoardHead) ->
  if Modal.record
    $scope.record = Modal.record
  else
    Board.get id: $routeParams.id, (data)->
      $scope.record = data
  $scope.board_head = SequencingConst.boardHeads[$scope.record.board_head_id]
  $scope.cols = $scope.board_head.cols.split ','
  $scope.rows = $scope.board_head.rows.split ','

  Board.records idsn: $scope.record.sn, (data)->
    if data
      $scope.boardRecords = {}
      angular.forEach data, (d)->
        $scope.boardRecords[d.hole] = d
  null
]
