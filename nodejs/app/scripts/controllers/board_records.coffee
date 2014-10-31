'use strict'

angular.module('sequencingApp').controller 'BoardRecordsCtrl', ['$scope', 'Modal', 'Sequencing', 'BoardRecord', ($scope, Modal, Sequencing, BoardRecord) ->
  $scope.board = Modal.board

  if $scope.board.procedure.record_name == 'abi_records'
    $scope.record = {data: {quadrant_sequence: '1,2,3,4', instrument: 'A', run_time: ''}, board_id: $scope.board.id}
  else
    $scope.record = {data: {remark: 'ok'}, board_id: $scope.board.id}

  $scope.save = ->
    record = {
      board_id: $scope.board.id
      procedure_id: $scope.board.procedure.id
      data: JSON.stringify($scope.record.data)
    }
    BoardRecord.create record, (data)->
      $scope.$close data
  $scope.timepicker = (dom_selector)->
    angular.element(dom_selector).datetimepicker()
    null

  $scope.instruments = Sequencing.abiInstruments
  null
]
