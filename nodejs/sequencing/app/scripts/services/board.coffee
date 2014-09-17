'use strict'

angular.module('sequencingApp').factory 'Board', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/boards/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/boards/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/boards/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
