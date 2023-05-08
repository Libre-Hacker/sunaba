-- Define a Lua class
John = {}

-- Define a constructor for the class
function John.new()
  local obj = {}
  setmetatable(obj, John)
  John.__index = John
  return obj
end

-- Define a method for the class
function John:start()
    Chat:print(John:name 'Hello World! Im an NPC')
end

function John:update()
    -- Do something
end

function John:physicsUpdate()
    -- Do something
end
