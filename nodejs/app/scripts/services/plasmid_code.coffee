'use strict'

angular.module('sequencingApp').factory 'PlasmidCode', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/plasmidCodes/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/plasmidCodes/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/plasmidCodes/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    all: {isArray: true, method: 'GET'}
  }
]
