'use strict'
angular.module('sequencingApp').factory 'Reaction', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/reactions/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/reactions/:id'}
    updates: {method: 'PUT', url: SequencingConst.api + '/reactions'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/reactions/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    dilute: {isArray: true, method: 'GET', url: SequencingConst.api + '/dilutePrimers'}
  }
]
