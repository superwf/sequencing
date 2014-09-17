'use strict'

angular.module('sequencingApp').factory 'flow', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/flows/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/flows/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/flows/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
