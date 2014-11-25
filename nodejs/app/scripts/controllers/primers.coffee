'use strict'

angular.module('sequencingApp').controller 'PrimersCtrl', ['$scope', 'Primer', 'Modal', '$modal', 'Sequencing', ($scope, Primer, Modal, $modal, Sequencing) ->
  $scope.$emit 'event:title', 'primer'
  $scope.searcher = {}

  $scope.search = ->
    Primer.query $scope.searcher, (data) ->
      angular.forEach data.records, (d)->
        d.create_date = new Date(d.create_date)
        d.expire_date = new Date(d.expire_date)
        d.operate_date = new Date(d.operate_date)
      $scope.records = data.records || []
      $scope.totalItems = data.totalItems
      $scope.perPage = data.perPage
      return
  $scope.search()

  $scope.config = Sequencing
 
  $scope.delete = (id, index)->
    Primer.delete {id: id}, ->
      $scope.records.splice index, 1
      return
    return

  $scope.create = ->
    Modal.record = {status: 'ok', store_type: '90days', need_return: false, origin_thickness: '5', create_date: Sequencing.date2string()}
    $modal.open {
      templateUrl: '/views/primer.html'
      controller: 'PrimerCtrl'
      size: 'lg'
    }
    .result.then (record)->
      $scope.records.unshift record
      return
    return

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/primer.html'
      controller: 'PrimerCtrl'
      size: 'lg'
    }
    return
  return
]
