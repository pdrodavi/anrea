const express = require('express')
const router = express.Router()

/* GET home page. */
router.get('/', function(req, res, next) {  
  res.render('index', { error: '' })
})

router.get('/doc', function(req, res, next) {  
  res.render('doc')
})

router.post('/angular', function(req, res, next) {
  
  let appName = req.body.name
  let requestAngularjson = req.body.textarea

  try {
    var jsonPost = JSON.parse(requestAngularjson)
  } catch (error) {
    res.render('index', { error: 'Conteúdo json inválido!' })
  }

  try {
    jsonPost.projects[appName].architect.build.options.outputPath = 'docs/'
  } catch (error) {
    res.render('index', { error: 'Nome da aplicação não é válida!' })
  }
  
  let resp = JSON.stringify(jsonPost)

  res.render('responseangular', { json: resp });

})


module.exports = router