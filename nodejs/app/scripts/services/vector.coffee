'use strict'

angular.module('sequencingApp').factory 'Vector', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/vectors/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/vectors/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/vectors/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
