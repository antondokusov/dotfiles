local glance = require 'glance'
glance.setup {
	mappings = {
		list = {
			['/'] = glance.actions.close,
		},
	},
}
