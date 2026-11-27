-- bind() is rex.bind plus a description, which the ctrl+space>? list shows.
-- A function becomes an action named after its key, so it can queue app actions and wait
-- for pickers (a function bound directly can do neither). Its description is its title
-- in the command palette.
local docs = {}
local function bind(key, desc, action, args)
  if type(action) == "function" then
    local name = "key_" .. key:gsub("%W", "_")
    rex.action({ name = name, title = desc, run = action })
    action = name
  end
  rex.bind(key, action, args)
  docs[#docs + 1] = { key = key, desc = desc }
end

bind("ctrl+space>ctrl+space", "Send ctrl+space to the program", "pane.send_key", { key = "ctrl+space" })
bind("ctrl+space>c", "New tab", "client.tab.new")
bind("ctrl+space>,", "Rename tab", "client.tab.rename")
bind("ctrl+space>-", "Split pane below", "pane.split", { direction = "down" })
bind("ctrl+space>shift+\\", "Split pane to the right", "pane.split", { direction = "right" })
bind("ctrl+space>ctrl+l", "Clear screen (ctrl+l moves panes)", "pane.send_key", { key = "ctrl+l" })

for i = 1, 9 do
  bind("ctrl+space>" .. i, "Go to tab " .. i, "client.tab.goto", { index = i })
end

-- Sessions. The server sees no event when the app changes session, so these keys remember
-- the session they leave; switches by clicking in the sidebar aren't remembered.
-- All of them use session.select: the app ignores session.next/previous/back from init.lua.
local last_session

local function go_to(ctx, session_id)
  if session_id and session_id ~= ctx.session_id then
    last_session = ctx.session_id
    rex.client.queue("session.select", { session_id = session_id })
  end
end

-- the id of the item picked, or nil when the picker is closed
local function pick_id(opts)
  local picked = rex.ui.pick(opts)
  if type(picked) == "table" then
    picked = picked.id or picked[1]
  end
  return picked
end

-- next (1) or previous (-1) session, in the order the picker numbers them
local function step(ctx, n)
  local sessions = rex.call("session.list", {}).sessions
  for i, s in ipairs(sessions) do
    if s.session_id == ctx.session_id then
      return go_to(ctx, sessions[(i - 1 + n) % #sessions + 1].session_id)
    end
  end
end

bind("ctrl+space>j", "Next session", function(ctx) step(ctx, 1) end)
bind("ctrl+space>k", "Previous session", function(ctx) step(ctx, -1) end)
bind("ctrl+space>shift+l", "Toggle to the last session", function(ctx) go_to(ctx, last_session) end)

bind("ctrl+space>s", "Pick a session (type its number)", function(ctx)
  local items = {}
  for i, s in ipairs(rex.call("session.list", {}).sessions) do
    items[i] = {
      id = s.session_id,
      title = i .. "  " .. s.label,
      detail = s.session_id == ctx.session_id and "current" or nil,
    }
  end
  go_to(ctx, pick_id({ title = "Sessions", placeholder = "Number or name", items = items }))
end)

-- ctrl+f: project picker (tmux-sessionizer). Goes to the session named after the folder,
-- creating it there first if there is none.
local home = os.getenv("HOME")
bind("ctrl+f", "Open a project session (creates it if needed)", function(ctx)
  local find = { "find", "-L", home .. "/git", home .. "/git/github", home .. "/git/DigitecGalaxus",
    home .. "/git/DigitecGalaxus/Bender", home .. "/notes", "-mindepth", "1", "-maxdepth", "1", "-type", "d" }
  local found = rex.exec(find) -- rex.exec(find).stdout in one go returns nil
  local items = {}
  for dir in found.stdout:gmatch("[^\n]+") do
    items[#items + 1] = { id = dir, title = dir:match("[^/]+$"), detail = "~" .. dir:sub(#home + 1):match("^(.*)/") }
  end
  table.sort(items, function(a, b) return a.title < b.title end)
  local dir = pick_id({ title = "Projects", placeholder = "Project", items = items })
  if not dir then
    return
  end
  local name = dir:match("[^/]+$")
  for _, s in ipairs(rex.call("session.list", {}).sessions) do
    if s.label == name then
      return go_to(ctx, s.session_id)
    end
  end
  local block = { flavor = "com.superlogical.terminal.shell", options = { cwd = dir } }
  go_to(ctx, rex.call("session.create", { label = name, initial_windows = { { layout = { block = block } } } }).session_id)
end)

-- ctrl+h/j/k/l: move between panes, but leave the key to nvim when it runs there.
-- smart-splits.nvim hands focus back to Rex at nvim's last split (see nvim/lua/plugins.lua).
for _, nav in ipairs({ { "left", "ctrl+h" }, { "down", "ctrl+j" }, { "up", "ctrl+k" }, { "right", "ctrl+l" } }) do
  local direction, key = nav[1], nav[2]
  bind(key, "Focus pane " .. direction .. " (nvim splits too)", function(ctx)
    local ok, p = pcall(rex.call, "block.method", { session_id = ctx.session_id, block_id = ctx.block_id, method = "process" })
    if ok and p and p.foreground and p.foreground.name == "nvim" then
      rex.client.queue("pane.send_key", { key = key })
    else
      rex.client.queue("pane.focus", { direction = direction })
    end
  end)
end

bind("ctrl+space>shift+/", "Show this list", function()
  local items = {}
  for i, d in ipairs(docs) do
    items[i] = { id = tostring(i), title = d.desc, detail = (d.key:gsub(">", "  ")) }
  end
  rex.ui.pick({ title = "Keybindings", placeholder = "Filter", items = items })
end)
