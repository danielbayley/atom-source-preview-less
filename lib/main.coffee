LessProvider = require './less-provider'

module.exports =
	activate: -> @provider = new LessProvider
	deactivate: -> @provider = null
	provide: -> @provider
