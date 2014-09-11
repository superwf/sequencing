'use strict'

angular.module('sequencingApp').factory 'PrimerHead', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/primerHeads/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/primerHeads/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/primerHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
