-- Define a Lua class
MyNPC = {}

-- Define a constructor for the class
function MyNPC.new()
  local obj = {}
  setmetatable(obj, MyNPC)
  MyNPC.__index = MyNPC
  return obj
end

-- Define a method for the class
function MyNPC:start()
    Chat::print('Hello World! Im an NPC')
end

function MyNPC:update()
    -- Do something
end

function MyNPC:physicsUpdate()
    -- Do something
end
