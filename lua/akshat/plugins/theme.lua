return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
	  	require("tokyonight").setup({
		  	style = "moon",
		  	transparent = true,
		  	terminal_colors = false
	  	})

	  	vim.cmd([[colorscheme tokyonight]])

  	    end

}
