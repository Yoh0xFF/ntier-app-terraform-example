export default (sequelize, DataTypes) => {
    return sequelize.define('user', {
        id: { type: DataTypes.BIGINT, allowNull: false, primaryKey: true, autoIncrement: true },
        email: { type: DataTypes.STRING, allowNull: false },
        fullName: { type: DataTypes.STRING, allowNull: false }
    });
};