'use strict'

angular.module('sequencingApp').factory 'SampleHead', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/sampleHeads/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/sampleHeads/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/sampleHeads/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
  }
]
