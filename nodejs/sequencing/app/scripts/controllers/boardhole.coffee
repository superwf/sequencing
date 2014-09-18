'use strict'
angular.module('sequencingApp').controller 'BoardHoleCtrl', ['BoardHead', 'Board', '$scope', 'Modal', '$rootScope', 'head', 'number','sn', (BoardHead, Board, $scope, Modal, $rootScope, head, number, sn) ->
  $scope.cols = head.cols.split(',')
  $scope.rows = head.rows.split(',')
  Board.query sn: sn, (data)->
    if data.records && data.records.length > 0
      $scope.board = data.records[0]
    else
      $scope.board = {id: null, sn: sn}
  $scope.sn = sn

  $scope.selectHole = (sn, hole, board_id)->
    $scope.$close {sn: sn, hole: hole, board: $scope.board}
]
