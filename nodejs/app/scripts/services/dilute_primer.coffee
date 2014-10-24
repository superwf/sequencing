'use strict'

angular.module('sequencingApp').factory 'DilutePrimer', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/dilutePrimers/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/dilutePrimers/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/dilutePrimers:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
