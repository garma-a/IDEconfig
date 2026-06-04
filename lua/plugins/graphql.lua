-- GraphQL support plugin
-- Provides filetype detection for .graphql/.gql files and
-- embedded GraphQL syntax highlighting in JS/TS/TSX via jparise/vim-graphql
return {
	{
		-- Adds filetype detection for .graphql / .gql files
		-- Also handles `gql` tagged template literal highlighting in JS/TS
		"jparise/vim-graphql",
		ft = { "graphql", "graphqls", "javascript", "javascriptreact", "typescript", "typescriptreact" },
		-- No config needed – the plugin does its thing on load
	},
}
