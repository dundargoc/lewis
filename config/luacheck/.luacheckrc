stds.nvim = {
  read_globals = { "jit" }
}

std = "lua51+nvim"

globals = {"vim"}

-- Rerun tests only if their modification time changed.
cache = true

-- vim: ft=lua