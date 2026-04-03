local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("gui-startup", function()
  local _, _, window = mux.spawn_window({})
  window:gui_window():set_window_size({ width = 1000, height = 1000 })
end)

-- Right status: workspace | Z (zoomed) | tmux session | cwd | time
wezterm.on("update-right-status", function(window, pane)
  local is_zoomed = false
  for _, pane_info in ipairs(window:active_tab():panes_with_info()) do
    if pane_info.is_active and pane_info.is_zoomed then
      is_zoomed = true
      break
    end
  end

  -- workspace name (skip "default")
  local workspace = window:active_workspace()
  local ws = (workspace and workspace ~= "default") and (" " .. workspace .. " ") or ""

  -- current working directory (shortened: ~/projects/foo -> ~/p/foo)
  local cwd_obj = pane:get_current_working_dir()
  local cwd = ""
  if cwd_obj then
    local path = cwd_obj.file_path or tostring(cwd_obj)
    -- replace HOME with ~
    path = path:gsub("^" .. os.getenv("HOME"), "~")
    -- shorten middle segments: ~/projects/foo/bar -> ~/p/foo/bar
    path = path:gsub("(/[^/])[^/]+(/)", "%1%2")
    cwd = " " .. path .. " "
  end

  -- tmux session name via pane title (set in .tmux.conf with set-titles-string "#S")
  local pane_title = pane:get_title()
  local proc = pane:get_foreground_process_name() or ""
  local in_tmux = proc:find("tmux") ~= nil
  local session = (in_tmux and pane_title ~= "") and (" " .. pane_title .. " ") or ""

  local zoom = is_zoomed and " Z " or ""
  local time = wezterm.strftime(" %H:%M ")

  window:set_right_status(wezterm.format({
    { Foreground = { Color = "#7aa2f7" } },
    { Text = ws },
    { Foreground = { Color = is_zoomed and "#f0a500" or "#555555" } },
    { Text = zoom },
    { Foreground = { Color = "#4e9a8a" } },
    { Text = session },
    { Foreground = { Color = "#666666" } },
    { Text = cwd },
    { Foreground = { Color = "#444444" } },
    { Text = time },
  }))
end)

-- wezterm.on("window-resized", function(window, pane)
-- 	readjust_font_size(window, pane)
-- end)

-- Readjust font size on window resize to get rid of the padding at the bottom
function readjust_font_size(window, pane)
  local window_dims = window:get_dimensions()
  local pane_dims = pane:get_dimensions()

  local config_overrides = {}
  local initial_font_size = 13 -- Set to your desired font size
  config_overrides.font_size = initial_font_size

  local max_iterations = 5
  local iteration_count = 0
  local tolerance = 3

  -- Calculate the initial difference between window and pane heights
  local current_diff = window_dims.pixel_height - pane_dims.pixel_height
  local min_diff = math.abs(current_diff)
  local best_font_size = initial_font_size

  -- Loop to adjust font size until the difference is within tolerance or max iterations reached
  while current_diff > tolerance and iteration_count < max_iterations do
    -- wezterm.log_info(window_dims, pane_dims, config_overrides.font_size)
    wezterm.log_info(
      string.format(
        "Win Height: %d, Pane Height: %d, Height Diff: %d, Curr Font Size: %.2f, Cells: %d, Cell Height: %.2f",
        window_dims.pixel_height,
        pane_dims.pixel_height,
        window_dims.pixel_height - pane_dims.pixel_height,
        config_overrides.font_size,
        pane_dims.viewport_rows,
        pane_dims.pixel_height / pane_dims.viewport_rows
      )
    )

    -- Increment the font size slightly
    config_overrides.font_size = config_overrides.font_size + 0.5
    window:set_config_overrides(config_overrides)

    -- Update dimensions after changing font size
    window_dims = window:get_dimensions()
    pane_dims = pane:get_dimensions()
    current_diff = window_dims.pixel_height - pane_dims.pixel_height

    -- Check if the current difference is the smallest seen so far
    local abs_diff = math.abs(current_diff)
    if abs_diff < min_diff then
      min_diff = abs_diff
      best_font_size = config_overrides.font_size
    end

    iteration_count = iteration_count + 1
  end

  -- If no acceptable difference was found, set the font size to the best one encountered
  if current_diff > tolerance then
    config_overrides.font_size = best_font_size
    window:set_config_overrides(config_overrides)
  end
end
