'use strict'

angular.module('sequencingApp').controller 'TypesetSamplesCtrl', ['$scope', 'Sample', 'Board', 'SequencingConst', ($scope, Sample, Board, SequencingConst) ->
  $scope.$emit 'event:title', 'sample_typeset'
  Sample.typesettingHeads (data)->
    $scope.heads = data

  $scope.board = {number: 1}
  $scope.$watch 'board.board_head + board.number', ->
    getRecords()
  getRecords = ->
    $scope.samples = {}
    if $scope.board.board_head
      headId = $scope.board.board_head.id
      $scope.board.board_head_id = headId
      Sample.typesetting board_head_id: headId, (data)->
        $scope.records = data
        null
      $scope.board.create_date = SequencingConst.date2string()
      $scope.cols = $scope.board.board_head.cols.split(',')
      $scope.rows = $scope.board.board_head.rows.split(',')
      $scope.board.sn = SequencingConst.boardSn($scope.board)
      sn = $scope.board.sn
      Board.records idsn: sn, (data)->
        if data
          $scope.boardRecords = {}
          angular.forEach data, (d)->
            $scope.boardRecords[d.hole] = d.name
            null
        null
    null

  $scope.samples = {}
  $scope.typeset = ->
    selected = angular.element('tr.ui-selected')
    holes = angular.element('.board td.ui-selected')
    if selected.length && holes.length
      for c in $scope.cols
        #continue1 = false
        for r in $scope.rows
          if ($scope.boardRecords[c] && $scope.boardRecords[c][r]) || ($scope.samples[c] && $scope.samples[c][r])
            continue
          hole = c + r
          holeDom = angular.element('td.hole.ui-selected[hole='+hole+']')
          tr = angular.element('tr.ui-selected:first')
          if holeDom.length && tr.length
            i = tr.attr('i') * 1
            sample = $scope.records[i]
            if !sample.typesetted
              sample.typesetted = true
              if !$scope.samples[c]
                $scope.samples[c] = {}
              $scope.samples[c][r] = sample
              tr.removeClass('ui-selected')
              holeDom.removeClass('ui-selected')
        #if continue1
        #  continue
    null
  $scope.clearHole = (c, r)->
    sample = $scope.samples[c][r]
    sample.typesetted = false
    $scope.samples[c][r] = null

  $scope.submit = ->
    board = SequencingConst.copyWithDate($scope.board, 'create_date')
    Board.create board, (data)->
      records = []
      for c in $scope.cols
        for r in $scope.rows
          if $scope.samples[c] && $scope.samples[c][r]
            sample = $scope.samples[c][r]
            records.push {
              id: sample.sample_id
              hole: c + r
              board_id: data.id
            }
      if records.length
        Sample.typeset records, ->
          getRecords()
      null
    null
  null
]
