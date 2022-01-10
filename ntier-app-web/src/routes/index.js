import express from 'express';

const router = express.Router();

/* GET home page. */
router.get('/', (req, res, next) => res.render('index', {title: 'N-Tier Web'}));

export default router;