'use strict'

angular.module('sequencingApp').controller 'CompanyTreeCtrl', ['$scope', 'CompanyTree', 'Company', '$modal', 'Modal', ($scope, CompanyTree, Company, $modal, Modal) ->

  $scope.inModal = !!$scope.$close
  $scope.$emit 'event:title', 'company'

  CompanyTree.records id: 0, (data)->
    $scope.record = {
      children: data
    }
    return

  $scope.expand = (record)->
    if record.children_count > 0
      if !record.children || record.children.length == 0
        CompanyTree.records id: record.id, (data)->
          record.children = data
      else
        record.children = []
    return
  $scope.delete = (record)->
    Company.delete id: record.id, ->
      record.deleted = true
      return
    return

  $scope.create = ->
    Modal.record = {}
    $modal.open {
      templateUrl: '/views/company.html'
      controller: 'CompanyCtrl'
    }
    .result.then (record)->
      if $scope.records
        $scope.records.unshift record
      return

  $scope.edit = (record)->
    Modal.record = record
    $modal.open {
      templateUrl: '/views/company.html'
      controller: 'CompanyCtrl'
    }
    return

  $scope.showTable = false

  $scope.showTree = ->
    $scope.showTable = false
    return

  $scope.searcher = {}
  $scope.search = ->
    $scope.showTable = true
    s = $scope.searcher
    if(s.name || s.code)
      Company.query s, (data)->
        $scope.records = data.records || []
        $scope.totalItems = data.totalItems
        $scope.perPage = data.perPage
    return
  return
]
