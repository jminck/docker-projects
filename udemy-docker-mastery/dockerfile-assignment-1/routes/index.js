var express = require('express');
var router = express.Router();
var hostname = require('os').hostname();

/* GET home page. */
router.get('/', function(req, res, next) {
  res.render('index', { title: 'Node.js Express App' });
  res.render('index', { hostname: hostname });
});



module.exports = router;


