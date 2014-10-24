'use strict'
angular.module('sequencingApp').factory 'ReactionFile', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/reactionFiles/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/reactionFiles/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/reactionFiles/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    download: {isArray: true, method: 'GET', url: SequencingConst.api + '/downloadingReactionFiles'}
    interpreting: {isArray: true, method: 'GET', url: SequencingConst.api + '/interpretingReactionFiles'}
    interprete: {method: 'PUT', url: SequencingConst.api + '/interprete'}
  }
]
