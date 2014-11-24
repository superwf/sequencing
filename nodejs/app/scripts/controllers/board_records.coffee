'use strict'

angular.module('sequencingApp').controller 'BoardRecordsCtrl', ['$scope', 'Modal', 'Sequencing', 'BoardRecord', 'Procedure', ($scope, Modal, Sequencing, BoardRecord, Procedure) ->
  $scope.board = Modal.board

  record_name = $scope.board.procedure.record_name
  if record_name == 'abi_records' || record_name == 'reaction_files'
    if $scope.board.abi_record
      $scope.record = {data: $scope.board.abi_record, board_id: $scope.board.id}
    else
      $scope.record = {data: {quadrant_sequence: '1,2,3,4', run_time: ''}, board_id: $scope.board.id}
  else
    $scope.record = {data: {remark: 'ok'}, board_id: $scope.board.id}

  $scope.save = ->
    if record_name == 'abi_records' || record_name == 'reaction_files'
      Procedure.query record_name: 'abi_records', (data)->
        procedure_id = data.records[0].id
        record = {
          board_id: $scope.board.id
          procedure_id: procedure_id
          data: JSON.stringify($scope.record.data)
        }
        BoardRecord.create record, (data)->
          $scope.$close data
    else
      record = {
        board_id: $scope.board.id
        procedure_id: $scope.board.procedure.id
        data: JSON.stringify($scope.record.data)
      }
      BoardRecord.create record, (data)->
        $scope.$close data
  $scope.timepicker = (dom_selector)->
    angular.element(dom_selector).datetimepicker()
    return

  $scope.instruments = Sequencing.abiInstruments
  return
]
