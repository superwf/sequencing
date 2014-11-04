'use strict'

angular.module('sequencingApp').controller 'TypesetReactionsCtrl', ['$scope', 'Vector', 'Sequencing', '$routeParams', 'Modal', 'Reaction', 'BoardHead', 'Board', ($scope, Vector, Sequencing, $routeParams, Modal, Reaction, BoardHead, Board) ->
  $scope.$emit 'event:title', 'typeset'
  # first get the sampleboards those can be typeset to reaction
  Board.typeseteReactionSampleBoards (data)->
    $scope.sampleBoards = data

  $scope.activeSampleBoard = null

  $scope.selectSampleBoard = (b)->
    $scope.activeSampleBoard = b
    if !b.records
      BoardHead.get id: b.board_head_id, (head)->
        b.cols = head.cols.split(',')
        b.rows = head.rows.split(',')
      Board.sampleBoardPrimers id: b.id, (data)->
        if data
          b.records = {}
          angular.forEach data, (d)->
            b.records[d.hole] ||= {}
            b.records[d.hole][d.reaction_id] = d

  getBoardHead = ->
    BoardHead.all {all: true, board_type: 'reaction', available: 1}, (data)->
      $scope.board_heads = data
      $scope.rb.number = 1
      if data.length == 0
        $rootScope.$broadcast 'event:notacceptable', {hint: 'sample type not_exist'}
  getBoardHead()

  today = Sequencing.date2string()
  $scope.rb = {records: {}, create_date: today, showAs: 'board', activeRB: 'board'}

  getBoardRecords = (sn)->
    if sn
      Board.records idsn: sn, (data)->
        if data
          $scope.rb.records = {}
          angular.forEach data, (d)->
            $scope.rb.records[d.hole] = d

  $scope.$watch 'rb.board_head.name + rb.number', (h)->
    if $scope.rb.board_head
      returnAll()
      $scope.rb.records = {}
      $scope.rb.sn = Sequencing.boardSn($scope.rb)
      Board.get id: $scope.rb.sn, (b)->
        if !b.status || b.status == 'new'
          $scope.rb.cols = $scope.rb.board_head.cols.split(',')
          $scope.rb.rows = $scope.rb.board_head.rows.split(',')
          getBoardRecords($scope.rb.sn)
        else
          $scope.$emit 'event:notacceptable', {hint: 'board status error'}
        null

    null


  $scope.selectReactionHole = (activeRB, hole)->
    $scope.rb.activeRB = activeRB
    angular.element('.reaction_board td.ui-selected').removeClass('ui-selected')
    angular.element('.reaction_board td[hole='+hole+']').addClass('ui-selected')
    null

  $scope.typeset = ->
    if $scope.rb.activeRB == 'board'
      cols = $scope.rb.cols
      rows = $scope.rb.rows
    else
      cols = $scope.rb[$scope.rb.activeRB].cols
      rows = $scope.rb[$scope.rb.activeRB].rows
    selected = angular.element('#sample_boards .active .ui-selected')
    reaction_hole = angular.element('.reaction_board .ui-selected')
    c = reaction_hole.attr('col')
    c_index = cols.indexOf(c)
    r = reaction_hole.attr('row')
    r_index = rows.indexOf(r)
    if selected.length && reaction_hole.length
      for sc in $scope.activeSampleBoard.cols
        for sr in $scope.activeSampleBoard.rows
          hole = sc + sr
          dom = angular.element('#sample_boards .active .reaction.ui-selected[hole=' + hole + ']')
          if dom.length
            reaction_id = dom.attr('reaction_id')
            reaction = $scope.activeSampleBoard.records[hole][reaction_id]
            if !reaction.reaction_hole
              inserted = false
              for ci, c of cols
                break if inserted
                for ri, r of rows
                  ci = parseInt(ci)
                  ri = parseInt(ri)
                  if (ci == c_index && ri >= r_index) || ci > c_index
                    if !$scope.rb.records[c+r]
                      hole = c+r
                      reaction.reaction_hole = hole
                      $scope.rb.records[hole] = reaction
                      $scope.selectReactionHole(hole)
                      inserted = true
                      break
    null

  $scope.returnReaction = (hole, reaction)->
    if !reaction.id
      reaction.reaction_hole = null
      delete $scope.rb.records[hole]

  returnAll = ->
    for hole, r of $scope.rb.records
      if !r.id
        r.reaction_hole = null
        delete $scope.rb.records[hole]

  $scope.canTypeset = ->
    !angular.equals $scope.rb.records, {}

  $scope.submit = ->
    board = {
      board_head_id: $scope.rb.board_head.id
      create_date: $scope.rb.create_date
      number: $scope.rb.number
    }
    board = Sequencing.copyWithDate(board, 'create_date')
    Board.create board, (data)->
      board_id = data.id
      if board_id > 0
        reactions = []
        for hole, reaction of $scope.rb.records
          if reaction.reaction_hole
            reactions.push {
              board_id: board_id
              id: reaction.reaction_id
              hole: reaction.reaction_hole
            }
        Reaction.typeset reactions, ->
          getBoardRecords($scope.rb.sn)
          null
      null

  $scope.rb.showAs = 'board'
  $scope.showAsBoard = ->
    $scope.rb.showAs = 'board'
    null

  $scope.showAsQudrant = ->
    $scope.rb.showAs = 'quadrant'
    cols = $scope.rb.cols
    if cols
      rows = $scope.rb.rows
      $scope.rb.q1 = {cols: [], rows: []}
      $scope.rb.q2 = {cols: [], rows: []}
      $scope.rb.q3 = {cols: [], rows: []}
      $scope.rb.q4 = {cols: [], rows: []}
      for ci, c of cols
        for ri, r of rows
          q = 'q' + Sequencing.quadrant(c+r)
          inArray = false
          for qc in $scope.rb[q].cols
            if qc == c
              inArray = true
              break
          if !inArray
            $scope.rb[q].cols.push c

          inArray = false
          for qr in $scope.rb[q].rows
            if qr == r
              inArray = true
              break
          if !inArray
            $scope.rb[q].rows.push r
    null

  null
]
