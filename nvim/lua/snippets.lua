local ls = require 'luasnip'

ls.add_snippets('all', {
  ls.snippet('date', {
    ls.function_node(function()
      return os.date '%Y-%m-%d'
    end),
  }),
})
