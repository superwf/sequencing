'use strict'
angular.module('sequencingApp').controller 'PrechecksCtrl', ['$scope', 'Modal', 'SequencingConst', 'Precheck', 'PrecheckCode', 'BoardHead', ($scope, Modal, SequencingConst, Precheck, PrecheckCode, BoardHead) ->
  $scope.board = Modal.board
  $scope.codes = SequencingConst.precheckCodes

  $scope.selectCode = (code)->
    angular.element("td.ui-selected").each ->
      hole = this.getAttribute("hole")
      $scope.records[hole].code_id = code.id
    null


  $scope.clearCode = (record)->
    record.code_id = null
    null

  boardHead = SequencingConst.boardHeads[$scope.board.board_head_id]
  $scope.cols = boardHead.cols.split(',')
  $scope.rows = boardHead.rows.split(',')
  Precheck.all all: true, board_id: $scope.board.id, (records)->
    if records
      $scope.records = {}
      angular.forEach records, (record)->
        $scope.records[record.hole] = {sample: record.sample, sample_id: record.sample_id, code_id: record.code_id}

  $scope.save = ->
    records = []
    angular.forEach $scope.records, (record)->
      records.push
        sample_id: record.sample_id
        code_id: record.code_id
    Precheck.create records, ->
      $scope.$close 'ok'
]
