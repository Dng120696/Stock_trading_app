// Import and register all your controllers from the importmap under controllers/*

import { application as app } from "controllers/application"

// Eager load all controllers defined in the import map under controllers/**/*_controller
import { eagerLoadControllersFrom } from "@hotwired/stimulus-loading"
eagerLoadControllersFrom("controllers", app)

import { Application } from '@hotwired/stimulus'
import ContentLoader from '@stimulus-components/content-loader'

const application = Application.start()
application.register('content-loader', ContentLoader)
// Lazy load controllers as they appear in the DOM (remember not to preload controllers in import map!)
// import { lazyLoadControllersFrom } from "@hotwired/stimulus-loading"
// lazyLoadControllersFrom("controllers", application)
