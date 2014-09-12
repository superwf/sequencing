'use strict'
angular.module('sequencingApp').controller 'BoardHoleCtrl', ['BoardHead', 'PrimerBoard', '$scope', 'Modal', '$rootScope', 'head', 'type', 'number','sn', (BoardHead, PrimerBoard, $scope, Modal, $rootScope, head, type, number, sn) ->
  if type == 'primer'
    $scope.cols = head.cols.split(',')
    $scope.rows = head.rows.split(',')
    PrimerBoard.query sn: sn, (data)->
      if data.records && data.records.length > 0
        $scope.board = data.records[0]
      else
        $scope.board = {id: null}
  $scope.sn = sn

  $scope.selectHole = (sn, hole, board_id)->
    $rootScope.$broadcast 'modal:selectHole', {sn: sn, hole: hole, board: $scope.board}
    Modal.modal.dismiss 'cancel'
    Modal.modal = null
]
