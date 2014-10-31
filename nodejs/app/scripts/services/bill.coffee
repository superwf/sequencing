'use strict'
angular.module('sequencingApp').factory 'Bill', ['Sequencing', '$resource', (Sequencing, $resource)->
  $resource Sequencing.api + '/bills/:id', id: '@id', {
    update: {method: 'PUT', url: Sequencing.api + '/bills/:id'}
    'delete': {method: 'DELETE', url: Sequencing.api + '/bills/:id'}
    create: {method: 'POST'}
    query: {isArray: false, method: 'GET'}
    bill_orders: {isArray: true, method: 'GET', url: Sequencing.api + '/billOrders/:bill_id'}
    update_bill_order: {method: 'PUT', url: Sequencing.api + '/billOrders'}
    delete_bill_order: {method: 'DELETE', url: Sequencing.api + '/billOrders/:id'}
  }
]
