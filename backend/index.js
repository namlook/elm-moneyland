'use strict';

const Hapi = require('hapi');
const Path = require('path');
const Boom = require('boom');
const Joi = require('joi');

const dbOpts = {
    url: 'mongodb://localhost:27017/moneyland',
    settings: {
        db: {
            native_parser: false
        }
    }
};

const server = new Hapi.Server({
    connections: {
        routes: {
            files: {
                relativeTo: Path.join(__dirname, '../dist')
            }
        }
    }
});

server.connection({ port: 3000 });

const plugins = [
    require('inert'),
    {
        register: require('hapi-mongodb'),
        options: dbOpts
    }
];

const _id2id = (doc) => {
    doc.id = doc._id;
    delete doc._id;
    return doc;
};

const id2_id = (doc) => {
    doc._id = doc.id;
    delete doc.id;
    return doc;
};

const expenseValidation = {
    id: Joi.string().allow(null),
    title: Joi.string().required(),
    date: Joi.date().required(),
    amount: Joi.number().required(),
    for: Joi.array().items(Joi.string().trim()).min(1),
    paidBy: Joi.string().trim().required(),
    categories: Joi.array().items(Joi.string().trim())
};

server.register(plugins, (err) => {

    if (err) {
        throw err;
    }

    server.route({
        method: 'GET',
        path: '/api/expenses',
        config: {
            validate: {
                query: {
                    _sort: Joi.string().allow(''),
                    _order: Joi.string().allow(['ASC', 'DESC']).default('ASC')
                }
            }
        },
        handler: function (request, reply) {
            const db = request.server.plugins['hapi-mongodb'].db;

            const query = request.query || {};
            console.log('query>', query);
            const order = query._order === 'DESC' ? '-' : '';
            const sort = query._sort ? [`${order}${query._sort}`] : [];

            db.collection('expenses').find({}, {sort}).toArray((err, documents) => {
                if (err) {
                    return reply(Boom.internal('Internal MongoDB error', err));
                }
                const result = documents.map(_id2id);
                return reply(result);
            });
        }
    });

    server.route({
        method: 'POST',
        path: '/api/expenses',
        config: {
            validate: {
                payload: expenseValidation
            }
        },
        handler: function (request, reply) {
            const db = request.server.plugins['hapi-mongodb'].db;

            db.collection('expenses').insert(id2_id(request.payload), {w: 1}, (err, results) => {
                if (err) {
                    return reply(Boom.internal('Internal MongoDB error', err));
                }

                const doc = results.ops[0];
                return reply(_id2id(doc));
            });

        }
    });

    server.route({
        method: 'PUT',
        path: '/api/expenses/{expenseId}',
        config: {
            validate: {
                params: {
                    expenseId: Joi.string()
                },
                payload: expenseValidation
            }
        },
        handler: function (request, reply) {
            const db = request.server.plugins['hapi-mongodb'].db;
            const ObjectID = request.server.plugins['hapi-mongodb'].ObjectID;
            const collection = db.collection('expenses');

            const doc = id2_id(request.payload);
            doc._id = ObjectID(doc._id);

            collection.findOne({_id: doc._id}, (findErr, item) => {

                if (findErr) {
                    return reply(Boom.badRequest(
                        `Cannot find a document with the following _id: ${doc._id}`, err));
                }

                collection.save(doc, {w: 1}, (err, response) => {
                    if (err) {
                        console.log('err>', err);
                        return reply(Boom.internal('Error while saving document', err));
                    }

                    if (response.result.ok === 1) {
                        return reply(_id2id(doc));
                    }
                    return reply(Boom.internal('Internal MongoDB error', response));
                });
            });

        }
    });


    server.route({
        method: 'DELETE',
        path: '/api/expenses/{expenseId}',
        config: {
            validate: {
                params: {
                    expenseId: Joi.string()
                }
            }
        },
        handler: function (request, reply) {
            const db = request.server.plugins['hapi-mongodb'].db;
            const ObjectID = request.server.plugins['hapi-mongodb'].ObjectID;

            const expenseId = ObjectID(request.params.expenseId);

            db.collection('expenses').remove({_id: expenseId}, {w: 1}, (err) => {
                if (err) {
                    console.log('err>', err);
                    return reply(Boom.internal('Internal MongoDB error', err));
                }

                return reply({});
            });

        }
    });

    server.route({
        method: 'GET',
        path: '/{param*}',
        handler: {
            directory: {
                path: '../dist',
                listing: true
            }
        }
    });

    server.start((err) => {

        if (err) {
            throw err;
        }
        console.log('Server running at:', server.info.uri);
    });
});
