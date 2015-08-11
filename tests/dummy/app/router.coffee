`import Ember from 'ember'`
`import config from './config/environment'`

Router = Ember.Router.extend
  location: config.locationType

router = Router.map ->
  @route 'index', path: '/'
  @route 'resize'

`export default router`

