'use strict'
angular.module('sequencingApp').factory 'Prepayment', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/prepayments/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/prepayments/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/prepayments/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
