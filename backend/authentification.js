
const Bcrypt = require('bcrypt');
const Crypto = require('crypto');
const Joi = require('joi');
const Boom = require('boom');

const validatePassword = function (request, login, password, callback) {
    const users = request.server.plugins['hapi-mongodb'].db.collection('users');
    users.findOne({login}, (err, user) => {
        if (err) {
            return reply(Boom.internal('Internal MongoDB error', err));
        }
        if (!user) {
            return callback(null, false);
        }

        Bcrypt.compare(password, user.password, (err, isValid) => {

            const token = Crypto.createHash('sha1').digest('hex');

            users.update({login}, {$set: {token}}, (err) => {
                callback(err, isValid, { login, token });
            });
        });
    });
};

exports.init = (server) => {
    server.auth.strategy('basic', 'basic', { validateFunc: validatePassword });

    server.auth.strategy('token', 'bearerAuth', {
        exposeRequest: true,
        validateFunction(token, request, callback) {
            const users = request.server.plugins['hapi-mongodb'].db.collection('users');

            users.findOne({token}, {fields: {_id: 0, password: 0}}, (err, user) => {
                if (err) {
                    return reply(Boom.internal('Internal MongoDB error', err));
                }
                if (!user) {
                    return callback(null, false, {});
                }
                return callback(null, true, user);
            });
        }
    });

    server.route({
        method: 'POST',
        path: '/api/auth',
        config: {
            payload: {
                login: Joi.string().required(),
                password: Joi.string().required()
            }
        },
        config: {
            // auth: false,
            handler: function (request, reply) {
                // reply(request.auth.credentials);
                const users = request.server.plugins['hapi-mongodb'].db.collection('users');
                const {login, password} = request.payload;

                users.findOne({login}, (err, user) => {
                    if (err) {
                        return reply(Boom.internal('Internal MongoDB error', err));
                    }
                    if (!user) {
                        return reply(Boom.unauthorized('unknown user'));

                    }

                    Bcrypt.compare(password, user.password, (bcrypterr, isValid) => {

                        if (bcrypterr) {
                            return reply(Boom.internal('Internal Bcrypt error', bcrypterr));
                        }

                        if (!isValid) {
                            return reply(Boom.unauthorized('invalid password'));
                        }
                        const token = Crypto.createHash('sha1').digest('hex');

                        users.update({login}, {$set: {token}}, (updateErr) => {
                            if (updateErr) {
                                return reply(Boom.internal('Internal MongoDB error', updateErr));
                            }

                            reply({ login, token });
                        });
                    });
                });
            }
        }
    });

    // server.route({
    //     method: 'GET',
    //     path: '/hello',
    //     config: {
    //         auth: 'token',
    //         handler: function (request, reply) {
    //             reply(request.auth.credentials);
    //         }
    //     }
    // });
};
