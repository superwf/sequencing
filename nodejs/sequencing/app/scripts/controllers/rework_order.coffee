'use strict'

angular.module('sequencingApp').controller 'ReworkOrderCtrl', ['$scope', 'Reaction', 'Modal', '$modal', 'SequencingConst', ($scope, Reaction, Modal, $modal, SequencingConst) ->
  Reaction.reworking (data) ->
    $scope.records = data || []
    for i, v of $scope.records
      if v.board_head_id
        $scope.records[i].board_head = SequencingConst.boardHeads[v.board_head_id]
      if v.precheck_code_id
        $scope.records[i].precheck_code = SequencingConst.precheckCodes[v.precheck_code_id]
      if v.interprete_code_id
        $scope.records[i].interprete_code = SequencingConst.interpreteCodes[v.interprete_code_id]
      if v.interpreter_id
        $scope.records[i].interpreter = SequencingConst.users[v.interpreter_id]
    null
 
]
