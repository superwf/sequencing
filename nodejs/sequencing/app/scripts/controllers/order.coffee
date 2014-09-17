'use strict'
angular.module('sequencingApp').controller 'OrderCtrl', ['$scope', 'Order', 'SequencingConst', '$routeParams', 'Modal', '$modal', 'BoardHead', 'Client', 'Vector', 'Primer', '$rootScope', 'Board', ($scope, Order, SequencingConst, $routeParams, Modal, $modal, BoardHead, Client, Vector, Primer, $rootScope, Board) ->
  $scope.transportCondition = SequencingConst.transportCondition
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.board_heads = data
    $scope.board_number = 1
    if data.length == 0
      $rootScope.$broadcast 'event:notacceptable', {hint: 'sample type not_exist'}
  if $routeParams.id == 'new'
    $scope.sample_number = 1
    $scope.record = {create_date: SequencingConst.date2string(), number: 1}
    $scope.board_create_date = SequencingConst.date2string()
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Order.get id: $routeParams.id

  # select board_head
  $scope.$watch 'record.board_head', ->
    if $scope.record.board_head
      $scope.record.board_head_id = $scope.record.board_head.id
      $scope.cols = $scope.record.board_head.cols.split(',')
      $scope.rows = $scope.record.board_head.rows.split(',')
      board = {board_head_id: $scope.record.board_head_id, create_date: $scope.board_create_date, number: $scope.board_number}
      board = SequencingConst.copyWithDate(board, 'create_date')
      Board.create board, (data)->
        $scope.board = data

  # input sample name
  $scope.samples = {}
  $scope.$watch 'sample_prefix + sample_number + sample_suffix', ->
    if typeof($scope.sample_number) == 'number'
      number = $scope.sample_number
      angular.forEach $scope.cols, (c)->
        angular.forEach $scope.rows, (r)->
          if angular.element('td[hole=' + r + c + ']').hasClass('ui-selected')
            name = ''
            if $scope.sample_prefix
              name = name + $scope.sample_prefix
            name += number
            number += 1
            if $scope.sample_suffix
              name = name + $scope.sample_suffix
            if !$scope.samples[c]
              $scope.samples[c] = {}
            if !$scope.samples[c][r]
              $scope.samples[c][r] = {}
            $scope.samples[c][r].name = name
    else
      name = ''
      if $scope.sample_prefix
        name = name + $scope.sample_prefix
      if $scope.sample_suffix
        name = name + $scope.sample_suffix
      if name
        angular.forEach $scope.cols, (c)->
          angular.forEach $scope.rows, (r)->
            if angular.element('td[hole=' + r + c + ']').hasClass('ui-selected')
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
        if angular.element('td[hole=' + r + c + ']').hasClass('ui-selected')
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
        if angular.element('td[hole=' + r + c + ']').hasClass('ui-selected')
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
        if angular.element('td[hole=' + r + c + ']').hasClass('ui-selected')
          if !$scope.samples[c]
            $scope.samples[c] = {}
          $scope.samples[c][r] = {}

  $scope.save = ->
    if $scope.record.id
      record = SequencingConst.copyWithDate($scope.record, 'create_date')
      Order.update record
    else
      samples = []
      angular.forEach $scope.samples, (v, c)->
        angular.forEach v, (v1, r)->
          if v1.name.length > 0 && v1.reactions && v1.reactions.length > 0
            sample = v1
            sample.hole = r + c
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
        , (err)->
          #$rootScope.$broadcast 'event:notacceptable', err.data
  null
]
