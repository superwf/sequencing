'use strict'

angular.module('sequencingApp').factory 'BoardHead', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/boardHeads/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/boardHeads/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/boardHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
