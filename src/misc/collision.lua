-- implementation based on 
-- http://devmag.org.za/2009/04/17/basic-collision-detection-in-2d-part-2/
   
-- p1 = { x=x, y=y } point 1
-- p2 = { x=x, y=y } point 2
-- ci = { x=x, y=y } circle center
-- r = radius of circle
-- return true if circle and line touch 
function circleLineCollision(p1, p2, ci, r)
        
    -- transform to local coordinates
    local lp1 = { x=p1.x-ci.x, y=p1.y-ci.y }
    local lp2 = { x=p2.x-ci.x, y=p2.y-ci.y }
    
    -- precalc difference between local points
    local lpd = { x=p2.x-p1.x, y=p2.y-p1.y}
    
    local a = lpd.x * lpd.x + lpd.y * lpd.y
    local b = 2 * ((lpd.x * lp1.x) + (lpd.y * lp1.y))
    local c = lp1.x * lp1.x + lp1.y * lp1.y - r * r
    local delta = b * b - (4 * a * c)
        
    if delta < 0 then return false end
    
    -- calculate bounding box
    local b1 = { x = math.min(p1.x, p2.x), y = math.min(p1.y, p2.y) }
    local b2 = { x = math.max(p1.x, p2.x), y = math.max(p1.y, p2.y) }
    
    -- return false if c is not in bound box
    if ci.y - r > b2.y then return false end
    if ci.y + r < b1.y then return false end
    if ci.x - r > b2.x then return false end
    if ci.x + r < b1.x then return false end
    
    return true
end