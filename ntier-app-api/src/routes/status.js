import express from 'express';
import axios from 'axios';
import * as aws from '../middlewares/aws';

const router = express.Router();

/* GET users listing. */
router.get('/', async (req, res, next) => {
    const data = await aws.ec2MetaData();

    res.render('status', data);
});

/* Ping to test Back-End with command line */
router.get('/ping', async (req, res, next) => {
    const data = await aws.ec2MetaData();

    res.set('Content-Type', 'text/plain');

    res.send(`(N-Tier API) Success! Hello from ${data.vpc.subnetBlock}, ${data.ip}!`);
});

/* Test console logs */
router.get('/log/info', async (req, res, next) => {
    console.log('This is info log!');

    res.set('Content-Type', 'text/plain');

    res.send('(N-Tier API) Success!');
});

router.get('/log/error', async (req, res, next) => {
    console.error('This is error log!');

    res.set('Content-Type', 'text/plain');

    res.send('(N-Tier API) Success!');
});

export default router;
