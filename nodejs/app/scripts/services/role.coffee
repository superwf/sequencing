'use strict'

angular.module('sequencingApp').factory 'Role', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/roles/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/roles/:id'}
    query: {isArray: false, method: 'GET'}
  }
]
