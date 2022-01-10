import express from 'express';

const router = express.Router();

/* GET home page. */
router.get('/', (req, res, next) => res.render('index', {title: 'ntier'}));

/* Ping to test Back-End with command line */
router.get('/ping', (req, res, next) => { res.set('Content-Type', 'text/plain'); res.send('Success!') });

export default router;