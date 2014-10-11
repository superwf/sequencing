'use strict'
angular.module('sequencingApp').factory 'Bill', ['SequencingConst', '$resource', (SequencingConst, $resource)->
  $resource SequencingConst.api + '/bills/:id', id: '@id', {
    update: {method: 'PUT', url: SequencingConst.api + '/bills/:id'}
    'delete': {method: 'DELETE', url: SequencingConst.api + '/bills/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    bill_orders: {isArray: true, method: 'GET', url: SequencingConst.api + '/billOrders/:bill_id'}
    update_bill_order: {method: 'PUT', url: SequencingConst.api + '/billOrders/:id'}
  }
]
