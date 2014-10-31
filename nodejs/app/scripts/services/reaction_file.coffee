'use strict'
angular.module('sequencingApp').factory 'ReactionFile', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/reactionFiles/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/reactionFiles/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/reactionFiles/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    download: {isArray: true, method: 'GET', url: Sequencing.api + '/downloadingReactionFiles'}
    interpreting: {isArray: true, method: 'GET', url: Sequencing.api + '/interpretingReactionFiles'}
    interprete: {method: 'PUT', url: Sequencing.api + '/interprete'}
  }
]
