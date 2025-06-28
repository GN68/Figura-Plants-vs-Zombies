local Events=require("lib.event")
local Debug={}
Debug.__index=Debug
Debug.ON_CLEAR=Events.new()

function Debug:setParent(parent)end
function Debug:getParent()end
function Debug:free()end
function Debug:clear()end
function Debug:setColor(r,g,b)end
function Debug:setOffset(x,y)end
function Debug:drawBox(x1,y1,x2,y2)end
function Debug:drawCircle(x,y,r)end
function Debug:drawPolygon(points)end
function Debug:drawLine(x1,y1,x2,y2)end

return Debug