'use strict'

angular.module('sequencingApp').factory 'Sample', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/samples/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/samples/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/samples/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
