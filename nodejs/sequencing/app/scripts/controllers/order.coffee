'use strict'
angular.module('sequencingApp').controller 'OrderCtrl', ['$scope', 'Order', 'SequencingConst', '$routeParams', 'Modal', '$modal', 'BoardHead', 'Client', 'Vector', 'Primer', '$rootScope', 'Board', ($scope, Order, SequencingConst, $routeParams, Modal, $modal, BoardHead, Client, Vector, Primer, $rootScope, Board) ->
  $scope.transportCondition = SequencingConst.transportCondition

  $scope.sample_board = {}
  getBoardHead = ->
    BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
      $scope.board_heads = data
      $scope.sample_board.number = 1
      if data.length == 0
        $rootScope.$broadcast 'event:notacceptable', {hint: 'sample type not_exist'}
  if $routeParams.id == 'new'
    $scope.sample_number = 1
    $scope.record = {create_date: SequencingConst.date2string(), number: 1, urgent: false, is_test: false}
    $scope.sample_board.create_date = $scope.record.create_date
    $scope.board_create_date = SequencingConst.date2string()
    $scope.inModal = false
    getBoardHead()
  else
    if Modal.record
      $scope.inModal = true
      $scope.record = Modal.record
      $scope.record.create_date = SequencingConst.date2string(Modal.record.create_date)
    else
      getBoardHead()
      $scope.record = Order.get id: $routeParams.id

  # select board_head
  $scope.$watch 'sample_board.board_head.name + sample_board.number + sample_board.create_date', ->
    if $scope.sample_board.board_head
      $scope.samples = []
      angular.element(".ui-selected").removeClass("ui-selected")
      $scope.record.board_head_id = $scope.sample_board.board_head.id
      $scope.cols = $scope.sample_board.board_head.cols.split(',')
      $scope.rows = $scope.sample_board.board_head.rows.split(',')
      $scope.sample_board.sn = SequencingConst.boardSn($scope.sample_board)
      getBoardRecords($scope.sample_board.sn)
  getBoardRecords = (sn)->
    Board.records idsn: sn, (data)->
      if data
        $scope.boardRecords = {}
        angular.forEach data, (d)->
          $scope.boardRecords[d.hole] = d.name

  # input sample name
  $scope.samples = {}
  $scope.sample = {}
  $scope.$watch 'sample.sample_prefix + sample.sample_number + sample.sample_suffix', ->
    if typeof($scope.sample.sample_number) == 'number'
      number = $scope.sample.sample_number
      angular.forEach $scope.cols, (c)->
        angular.forEach $scope.rows, (r)->
          if angular.element('td.hole[hole=' + c + r + ']').hasClass('ui-selected')
            name = ''
            if $scope.sample.sample_prefix
              name = name + $scope.sample.sample_prefix
            name += number
            number += 1
            if $scope.sample.sample_suffix
              name = name + $scope.sample.sample_suffix
            if !$scope.samples[c]
              $scope.samples[c] = {}
            if !$scope.samples[c][r]
              $scope.samples[c][r] = {}
            $scope.samples[c][r].name = name
    else
      name = ''
      if $scope.sample.sample_prefix
        name = name + $scope.sample.sample_prefix
      if $scope.sample.sample_suffix
        name = name + $scope.sample.sample_suffix
      if name
        angular.forEach $scope.cols, (c)->
          angular.forEach $scope.rows, (r)->
            if angular.element('td.hole[hole=' + c + r + ']').hasClass('ui-selected')
              if !$scope.samples[c]
                $scope.samples[c] = {}
              if !$scope.samples[c][r]
                $scope.samples[c][r] = {}
              $scope.samples[c][r].name = name

  $scope.selectClient = ->
    Modal.resource = Client
    modal = $modal.open {
      templateUrl: '/views/clients.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.record.client = data.name
      $scope.record.client_id = data.id
      null

  # select vector
  $scope.selectVector = ->
    Modal.resource = Vector
    modal = $modal.open {
      templateUrl: '/views/vectors.html'
      controller: 'ModalTableCtrl'
      resolve:
        searcher: ->
          {}
    }
    modal.result.then (data)->
      $scope.vector = data.name
      $scope.vector_id = data.id
      $scope.addVector()
      null
  $scope.addVector = ->
    if !$scope.vector_id
      return
    angular.forEach $scope.cols, (c)->
      angular.forEach $scope.rows, (r)->
        if angular.element('td[hole=' + c + r + ']').hasClass('ui-selected')
          if !$scope.samples[c]
            $scope.samples[c] = {}
          if !$scope.samples[c][r]
            $scope.samples[c][r] = {}
          $scope.samples[c][r].vector = $scope.vector
          $scope.samples[c][r].vector_id = $scope.vector_id
  $scope.deleteVector = (sample)->
    sample.vector = null
    sample.vector_id = null

  # select primer
  $scope.selectPrimer = ->
    Modal.resource = Primer
    modal = $modal.open {
      templateUrl: '/views/primers.html'
      controller: 'ModalTableCtrl'
      size: 'lg'
      resolve:
        searcher: ->
          {available: true, client_id: $scope.record.client_id}
    }
    modal.result.then (data)->
      $scope.primer = data.name
      $scope.primer_id = data.id
      $scope.addPrimer()
      null
  $scope.addPrimer = ->
    if !$scope.primer_id
      return
    angular.forEach $scope.cols, (c)->
      angular.forEach $scope.rows, (r)->
        if angular.element('td[hole=' + c + r + ']').hasClass('ui-selected')
          if !$scope.samples[c]
            $scope.samples[c] = {}
          if !$scope.samples[c][r]
            $scope.samples[c][r] = {}
          if !$scope.samples[c][r].reactions
            $scope.samples[c][r].reactions = []
          primer = {primer: $scope.primer, primer_id: $scope.primer_id}
          inArray = false
          angular.forEach $scope.samples[c][r].reactions, (p) ->
            if p.primer_id == primer.primer_id
              inArray = true
              false
            else
              true
          if !inArray
            $scope.samples[c][r].reactions.push primer
  $scope.deletePrimer = (reactions, index)->
    reactions.splice index, 1

  $scope.clearSample = ->
    angular.forEach $scope.cols, (c)->
      angular.forEach $scope.rows, (r)->
        if angular.element('td[hole=' + c + r + ']').hasClass('ui-selected')
          if !$scope.samples[c]
            $scope.samples[c] = {}
          $scope.samples[c][r] = {}

  $scope.save = ->
    if $scope.record.id
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      Order.update record
    else
      board = {
        board_head_id: $scope.sample_board.board_head.id
        number: $scope.sample_board.number
        create_date: $scope.sample_board.create_date
      }
      board = SequencingConst.copyWithDate(board, 'create_date')
      Board.create board, (data)->
        $scope.board = data
        samples = []
        angular.forEach $scope.samples, (v, c)->
          angular.forEach v, (v1, r)->
            if v1.name.length > 0 && v1.reactions && v1.reactions.length > 0
              sample = v1
              sample.hole = c + r
              sample.board_id = $scope.board.id
              samples.push v1
        if samples.length == 0
          $rootScope.$broadcast 'event:notacceptable', hint: 'sample not_exist'
        else
          record = SequencingConst.copyWithDate($scope.record, 'create_date')
          record.samples = samples
          Order.create record, (data)->
            if data.id > 0
              $scope.record.id = data.id
              $scope.samples = []
              getBoardRecords($scope.board.sn)
              angular.element(".ui-selected").removeClass("ui-selected")
          #, (err)->
          #  $rootScope.$broadcast 'event:notacceptable', err.data
  null
]
