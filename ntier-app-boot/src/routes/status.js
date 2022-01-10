import express from 'express';
import axios from 'axios';
import * as aws from '../middlewares/aws';

const router = express.Router();

/* GET users listing. */
router.get('/', async (req, res, next) => {
    const data = await aws.ec2MetaData();
    res.render('status', data);
});

export default router;
