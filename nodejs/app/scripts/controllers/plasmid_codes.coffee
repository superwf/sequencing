'use strict'

angular.module('sequencingApp').controller 'PlasmidCodesCtrl', ['$scope', 'PlasmidCode', 'Modal', '$modal', ($scope, PlasmidCode, Modal, $modal) ->
  $scope.$emit 'event:title', 'plasmid_code'
  $scope.searcher = {}
  $scope.search = ->
    PlasmidCode.query $scope.searcher, (data) ->
      $scope.records = data.records || []
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()
 
  $scope.delete = (id, index)->
    PlasmidCode.delete {id: id}
    $scope.records.splice index, 1

  $scope.create = ()->
    Modal.record = {available: true}
    $modal.open {
      templateUrl: '/views/plasmidCode.html'
      controller: 'PlasmidCodeCtrl'
    }
    .result.then (record)->
      $scope.records.unshift record

  $scope.edit = (record)->
    Modal.record = record
    $modal.open {
      templateUrl: '/views/plasmidCode.html'
      controller: 'PlasmidCodeCtrl'
    }
]
