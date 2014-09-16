'use strict'
angular.module('sequencingApp').controller 'OrderCtrl', ['$scope', 'Order', 'SequencingConst', '$routeParams', 'Modal', '$modal', 'BoardHead', 'Client', 'Vector', 'Primer', '$rootScope', ($scope, Order, SequencingConst, $routeParams, Modal, $modal, BoardHead, Client, Vector, Primer, $rootScope) ->
  $scope.transportCondition = SequencingConst.transportCondition
  BoardHead.all {all: true, board_type: 'sample', available: 1}, (data)->
    $scope.sample_heads = data
    if data.length == 0
      $rootScope.$broadcast 'event:notacceptable', {hint: 'sample_head not_exist'}
  if $routeParams.id == 'new'
    $scope.record = {}
  else
    if Modal.record
      $scope.record = Modal.record
    else
      $scope.record = Order.get id: $routeParams.id

  # select sample_head
  $scope.$watch 'record.sample_head', ->
    if $scope.record.sample_head
      $scope.cols = $scope.record.sample_head.cols.split(',')
      $scope.rows = $scope.record.sample_head.rows.split(',')

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
          {available: true}
    }
    modal.result.then (data)->
      $scope.primer = data.name
      $scope.primer_id = data.id
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
      Order.update $scope.record
    else
      samples = []
      angular.forEach $scope.samples, (k, v)->
        sample = {}
        sample = v
        sample.hole = k
        if sample.name.length > 0 && sample.reactions.length > 0
          samples.push sample
      if samples.length == 0
        $rootScope.$broadcast 'event:notacceptable', hint: 'sample not_exist'
      else
        $scope.record.samples = samples
        Order.create $scope.record, (data)->
          $scope.record = data
  null
]
