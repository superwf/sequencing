'use strict'
angular.module('sequencingApp').factory 'PrepaymentRecord', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/prepaymentRecords/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/prepaymentRecords/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/prepaymentRecords/:id'}
    create: {method: 'POST'}
    query: {isArray: true, method: 'GET'}
  }
]
