import '~/stylesheets/typography.css'
import '~/stylesheets/user.css'

import 'htmx.org';

import { Application } from "@hotwired/stimulus"

import HelloController from "~/controllers/hello_controller"
import ClipboardController from "~/controllers/clipboard_controller"

window.Stimulus = Application.start()
Stimulus.register("hello", HelloController)
Stimulus.register("clipboard", ClipboardController)
