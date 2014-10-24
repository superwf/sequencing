'use strict'

angular.module('sequencingApp').factory 'ClientReaction', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/clientReactions/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/clientReactions/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/clientReactions/:id'}
    'deleteAll': {method: 'DELETE'}
    query: {isArray: false, method: 'GET'}
  }
]
