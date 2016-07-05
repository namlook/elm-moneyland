'use strict';

const Hapi = require('hapi');
const Path = require('path');
const Expenses = require('./expenses');
const Authentification = require('./authentification');

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
    require('hapi-auth-basic'),
    require('hapi-auth-bearer-simple'),
    require('inert'),
    {
        register: require('hapi-mongodb'),
        options: dbOpts
    }
];



server.register(plugins, (err) => {

    if (err) {
        throw err;
    }

    Authentification.init(server);

    Expenses.routes(server);

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
