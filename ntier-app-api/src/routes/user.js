import express from 'express';
import model from '../models';

const router = express.Router();

// Create new user
router.put('/', async (req, res, next) => {
    res.send(await model.user.create(req.body));
});

// Edit existing user
router.post('/:userId', async (req, res, next) => {
    const userId = req.params.userId;
    if (!userId) {
        res.status(404).send('Not found!');
        return;
    }

    if (!(await model.user.find({ where: { id: userId } }))) {
        res.status(404).send('Not found!');
        return;
    }

    await model.user.update({
        email: req.body.email, fullName: req.body.fullName
    }, {
        where: { id: userId }
    });
    res.send(await model.user.find({ where: { id: userId } }));
});

// Delete existing user
router.delete('/:userId', async (req, res, next) => {
    const userId = req.params.userId;
    if (!userId) {
        res.status(404).send('Not found!');
        return;
    }

    const user = await model.user.find({ where: { id: userId } });
    if (!user) {
        res.status(404).send('Not found!');
        return;
    }

    await model.user.destroy({ where: { id: userId } });
    res.send(user);
});

// Ger users listing
router.get('/:userId*?', async (req, res, next) => {
    const userId = req.params.userId;

    if (userId) {
        const user = await model.user.find({ where: { id: userId } });

        if (!user) {
            res.status(404).send('Not found!');
        } else {
            res.send(user);
        }

        return;
    }

    const users = await model.user.findAll({ order: [ [ 'id', 'desc' ] ] });
    res.send(users);
});

export default router;
