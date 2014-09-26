'use strict'

angular.module('sequencingApp').controller 'BoardCtrl', ['$scope', 'Board', 'SequencingConst', '$routeParams', 'Modal', 'BoardHead', ($scope, Board, SequencingConst, $routeParams, Modal, BoardHead) ->
  if Modal.record
    $scope.record = Modal.record
  else
    Board.get id: $routeParams.id, (data)->
      $scope.record = data
  BoardHead.get id: $scope.record.board_head_id, (board_head)->
    $scope.cols = board_head.cols.split ','
    $scope.rows = board_head.rows.split ','

  Board.records idsn: $scope.record.sn, (data)->
    if data
      $scope.boardRecords = {}
      angular.forEach data, (d)->
        $scope.boardRecords[d.hole] = d.name
  null
]
