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
      $scope.reaction_board.number = 1
      if data.length == 0
        $rootScope.$broadcast 'event:notacceptable', {hint: 'sample type not_exist'}
  getBoardHead()

  today = Sequencing.date2string()
  $scope.reaction_board = {records: {}, create_date: today}

  getBoardRecords = (sn)->
    if sn
      Board.records idsn: sn, (data)->
        if data
          $scope.reaction_board.records = {}
          angular.forEach data, (d)->
            $scope.reaction_board.records[d.hole] = d

  $scope.$watch 'reaction_board.board_head.name + reaction_board.board_number', (h)->
    returnAll()
    if $scope.reaction_board.board_head
      $scope.reaction_board.sn = Sequencing.boardSn($scope.reaction_board)
      $scope.reaction_board.cols = $scope.reaction_board.board_head.cols.split(',')
      $scope.reaction_board.rows = $scope.reaction_board.board_head.rows.split(',')
    getBoardRecords($scope.reaction_board.sn)

    null


  $scope.selectReactionHole = (hole)->
    angular.element('#reaction_board td.ui-selected').removeClass('ui-selected')
    angular.element('#reaction_board td[hole='+hole+']').addClass('ui-selected')
    null

  $scope.transfer = ->
    selected = angular.element('#sample_boards .active .ui-selected')
    reaction_hole = angular.element('#reaction_board .ui-selected')
    return if !$scope.reaction_board
    c = reaction_hole.attr('col')
    c_index = $scope.reaction_board.cols.indexOf(c)
    r = reaction_hole.attr('row')
    r_index = $scope.reaction_board.rows.indexOf(r)
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
              for ci, c of $scope.reaction_board.cols
                break if inserted
                for ri, r of $scope.reaction_board.rows
                  ci = parseInt(ci)
                  ri = parseInt(ri)
                  if (ci == c_index && ri >= r_index) || ci > c_index
                    if !$scope.reaction_board.records[c+r]
                      hole = c+r
                      reaction.reaction_hole = hole
                      $scope.reaction_board.records[hole] = reaction
                      $scope.selectReactionHole(hole)
                      inserted = true
                      break
    null

  $scope.returnReaction = (hole, reaction)->
    if !reaction.id
      reaction.reaction_hole = null
      delete $scope.reaction_board.records[hole]

  returnAll = ->
    for hole, r of $scope.reaction_board.records
      if !r.id
        r.reaction_hole = null
        delete $scope.reaction_board.records[hole]

  $scope.typeset = ->
    board = {
      board_head_id: $scope.reaction_board.board_head.id
      create_date: $scope.reaction_board.create_date
      number: $scope.reaction_board.number
    }
    board = Sequencing.copyWithDate(board, 'create_date')
    Board.create board, (data)->
      board_id = data.id
      if board_id > 0
        reactions = []
        for hole, reaction of $scope.reaction_board.records
          if reaction.reaction_hole
            reactions.push {
              board_id: board_id
              id: reaction.reaction_id
              hole: reaction.reaction_hole
            }
        Reaction.updates reactions, ->
          getBoardRecords($scope.reaction_board.sn)
          null
      null
  null
]
