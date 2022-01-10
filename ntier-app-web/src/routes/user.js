import express from 'express';
import axios from 'axios';

const router = express.Router();

const apiUrl = process.env.NTIER_API_URL || 'http://localhost:8080';

// Show new user form
router.get('/new', async (req, res, next) => {
    res.render('user/edit', {user: {id: 0, email: '', fullName: ''}, title: 'New user'});
});

// Show edit user form
router.get('/:userId/edit', async (req, res, next) => {
    const userId = req.params.userId;

    try {
        const user = (await axios.get(`${apiUrl}/user/${userId}`)).data;

        res.render('user/edit', {user: user, title: 'Edit user'});
    } catch (err) {
        console.error(err);
        res.redirect('/user');
    }
});

// Save user
router.post('/', async (req, res, next) => {
    const user = {
        id: parseInt(req.body.id),
        email: req.body.email,
        fullName: req.body.fullName
    };

    try {
        if (user.id === 0) {
            await axios.put(`${apiUrl}/user`, user);
        } else {
            await axios.post(`${apiUrl}/user/${user.id}`, user);
        }
    } catch (err) {
        console.error(err);
    }

    res.redirect('/user');
});

// Delete existing user
router.get('/:userId/delete', async (req, res, next) => {
    const userId = req.params.userId;

    try {
        await axios.delete(`${apiUrl}/user/${userId}`);
    } catch (err) {
        console.error(err);
    }

    res.redirect('/user');
});

// Get users listing.
router.get('/', async (req, res, next) => {
    try {
        const users = (await axios.get(`${apiUrl}/user`)).data;

        res.render('user/list', {users: users});
    } catch (err) {
        console.error(err);

        res.render('user/list', {users: []});
    }
});

export default router;
