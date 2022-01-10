import fs from 'fs';
import path from 'path';
import Sequelize from 'sequelize';

const dbhost = process.env.NTIER_DB_HOST || 'locahost';
const dbschema = process.env.NTIER_DB_SCHEMA || 'ntier';
const dbuser = process.env.NTIER_DB_USERNAME || 'root';
const dbpass = process.env.NTIER_DB_PASSWORD || 'root';

// init database
const sequelize = new Sequelize(dbschema, dbuser, dbpass, {
    host: dbhost,
    dialect: 'mysql',
    operatorsAliases: false,

    pool: {
        max: 5,
        min: 0,
        acquire: 30000,
        idle: 10000
    }
});

const db = {
    sequelize,
    Sequelize
};

// define models
const basename = path.basename(__filename);

fs.readdirSync(__dirname)
    .filter(file => {
        return (file.indexOf('.') !== 0)
            && (file !== basename)
            && (file.slice(-3) === '.js');
    })
    .forEach(file => {
        const model = sequelize['import'](path.join(__dirname, file));
        db[model.name] = model;
    });

sequelize.sync();

export default db;