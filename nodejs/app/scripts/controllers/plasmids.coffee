'use strict'

angular.module('sequencingApp').controller 'PlasmidsCtrl', ['$scope', 'Modal', 'Sequencing', 'Plasmid', 'PlasmidCode', 'BoardHead', ($scope, Modal, Sequencing, Plasmid, PlasmidCode, BoardHead) ->
  $scope.board = Modal.board
  $scope.codes = {}
  PlasmidCode.all all: true, (codes)->
    angular.forEach codes, (code)->
      $scope.codes[code.id] = code

  $scope.selectCode = (code)->
    angular.element("td.ui-selected").each ->
      hole = this.getAttribute("hole")
      $scope.records[hole].code_id = code.id
    null


  $scope.clearCode = (record)->
    record.code_id = null
    null

  BoardHead.get id: Modal.board.board_head_id, (head)->
    $scope.cols = head.cols.split(',')
    $scope.rows = head.rows.split(',')
  Plasmid.all all: true, board_id: $scope.board.id, (records)->
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
    Plasmid.create records, ->
      $scope.$close 'ok'
]
