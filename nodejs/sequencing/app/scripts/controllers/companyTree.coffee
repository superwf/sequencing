'use strict'

angular.module('sequencingApp').controller 'CompanyTreeCtrl', ['$scope', 'CompanyTree', 'Company', '$modal', 'Modal', ($scope, CompanyTree, Company, $modal, Modal) ->
  CompanyTree.records id: 0, (data)->
    $scope.record =
      children: data
    return

  $scope.expand = (record)->
    if record.children_count > 0
      if !record.children || record.children.length == 0
        CompanyTree.records id: record.id, (data)->
          record.children = data
      else
        record.children = []
    null
  $scope.delete = (record)->
    Company.delete id: record.id, ->
      record.deleted = true

  $scope.edit = (record)->
    Modal.record = record
    Modal.modal = $modal.open {
      templateUrl: '/views/company.html'
      controller: 'CompanyCtrl'
    }
  null
]
