----------------------------------------------------------------
-- Copyright (c) 2010-2011 Zipline Games, Inc. 
-- All Rights Reserved. 
-- http://getmoai.com
----------------------------------------------------------------
W=1024
H=768

local sz = 6 -- body size
local cubenums = 8 -- num of cubes in a body
local N = 500 -- num of bodies




MOAISim.openWindow ( "test", W, H )
MOAIGfxDevice.setClearDepth ( true )

viewport = MOAIViewport.new ()
viewport:setSize ( W, H )
viewport:setScale ( W, H )

layer = MOAILayer.new ()
layer:setViewport ( viewport )
layer:setSortMode ( MOAILayer.SORT_NONE ) -- don't need layer sort
MOAISim.pushRenderPass ( layer )


vertexFormat = MOAIVertexFormat.new ()

vertexFormat:declareCoord ( 1, MOAIVertexFormat.GL_FLOAT, 3 )
vertexFormat:declareUV ( 2, MOAIVertexFormat.GL_FLOAT, 2 )
vertexFormat:declareColor ( 3, MOAIVertexFormat.GL_UNSIGNED_BYTE )


function writeCube1(vbo, dx,dy,dz)
   -- 1: top back left
   vbo:writeFloat ( -sz+dx, sz+dy, -sz+dz )
   vbo:writeFloat ( 0, 1 )
   vbo:writeColor32 ( 0.5, 1, 1 )

   -- 2: top back right
   vbo:writeFloat ( sz+dx, sz+dy, -sz+dz )
   vbo:writeFloat ( 1, 1 )
   vbo:writeColor32 ( 1, 0.5, 1 )

   -- 3: top front right
   vbo:writeFloat ( sz+dx, sz+dy, sz+dz )
   vbo:writeFloat ( 1, 0 )
   vbo:writeColor32 ( 0.5, 1, 0.5 )

   -- 4: top front left
   vbo:writeFloat ( -sz+dx, sz+dy, sz+dz )
   vbo:writeFloat ( 0, 0 )
   vbo:writeColor32 ( 1, 0.5, 0.5 )

   -- 5: bottom back left
   vbo:writeFloat ( -sz+dx, -sz+dy, -sz+dz )
   vbo:writeFloat ( 0, 1 )
   vbo:writeColor32 ( 1, 1, 1 )

   -- 6: bottom back right
   vbo:writeFloat ( sz+dx, -sz+dy, -sz+dz )
   vbo:writeFloat ( 1, 1 )
   vbo:writeColor32 ( 1, 0.5, 0.5 )

   -- 7: bottom front right
   vbo:writeFloat ( sz+dx, -sz+dy, sz+dz )
   vbo:writeFloat ( 1, 0 )
   vbo:writeColor32 ( 0.5, 0.5, 1 )

   -- 8: bottom front left
   vbo:writeFloat ( -sz+dx, -sz+dy, sz+dz )
   vbo:writeFloat ( 0, 0 )
   vbo:writeColor32 ( 1, 1, 0.5 )
end


function writeCubeIndex1(ibo,di,vi)
   -- front
   ibo:setIndex ( 1+di, 3+vi )
   ibo:setIndex ( 2+di, 4+vi )
   ibo:setIndex ( 3+di, 8+vi )
   ibo:setIndex ( 4+di, 8+vi )
   ibo:setIndex ( 5+di, 7+vi )
   ibo:setIndex ( 6+di, 3+vi )

   -- right
   ibo:setIndex ( 7+di, 2+vi )
   ibo:setIndex ( 8+di, 3+vi )
   ibo:setIndex ( 9+di, 7+vi )
   ibo:setIndex ( 10+di, 7+vi )
   ibo:setIndex ( 11+di, 6+vi )
   ibo:setIndex ( 12+di, 2+vi )

   -- back
   ibo:setIndex ( 13+di, 1+vi )
   ibo:setIndex ( 14+di, 2+vi )
   ibo:setIndex ( 15+di, 6+vi )
   ibo:setIndex ( 16+di, 6+vi )
   ibo:setIndex ( 17+di, 5+vi )
   ibo:setIndex ( 18+di, 1+vi )

   -- left
   ibo:setIndex ( 19+di, 4+vi )
   ibo:setIndex ( 20+di, 1+vi )
   ibo:setIndex ( 21+di, 5+vi )
   ibo:setIndex ( 22+di, 5+vi )
   ibo:setIndex ( 23+di, 8+vi )
   ibo:setIndex ( 24+di, 4+vi )

   -- top
   ibo:setIndex ( 25+di, 2+vi )
   ibo:setIndex ( 26+di, 1+vi )
   ibo:setIndex ( 27+di, 4+vi )
   ibo:setIndex ( 28+di, 4+vi )
   ibo:setIndex ( 29+di, 3+vi )
   ibo:setIndex ( 30+di, 2+vi )

   -- bottom
   ibo:setIndex ( 31+di, 8+vi )
   ibo:setIndex ( 32+di, 5+vi )
   ibo:setIndex ( 33+di, 6+vi )
   ibo:setIndex ( 34+di, 6+vi )
   ibo:setIndex ( 35+di, 7+vi )
   ibo:setIndex ( 36+di, 8+vi )
end


vbo = MOAIVertexBuffer.new ()
vbo:setFormat ( vertexFormat )

vbo:reserveVerts ( 8 * cubenums * cubenums * cubenums )
for cx=1,cubenums do
   for cy=1, cubenums do
      for cz=1, cubenums do
         writeCube1(vbo, (cx-1)*sz*3,(cy-1)*sz*3,(cz-1)*sz*3)
      end
   end
end

vbo:bless ()

ibo = MOAIIndexBuffer.new ()
ibo:reserve ( 36 * cubenums * cubenums * cubenums )
--writeCubeIndex1(ibo,0)
for cx=1,cubenums do
   for cy=1, cubenums do
      for cz=1, cubenums do
         local cubeind = ((cx-1)*cubenums*cubenums + (cy-1)*cubenums + (cz-1)) -- from 0
         writeCubeIndex1(ibo, cubeind * 36, cubeind *8)
      end
   end
end



print("mmm")
mesh = MOAIMesh.new ()
--mesh:setTexture ( "white.png" )
mesh:setTexture ( "cathead.png" )
mesh:setVertexBuffer ( vbo )
mesh:setIndexBuffer ( ibo )
mesh:setPrimType ( MOAIMesh.GL_TRIANGLES )
print("nnn")

cubes = {}


for i=1,N do
   prop = MOAIProp.new ()
   prop:setDeck ( mesh )
   prop:setCullMode ( MOAIProp.CULL_BACK )
   prop:setDepthTest ( MOAIProp.DEPTH_TEST_LESS_EQUAL )
   prop:setLoc( -W/4 + W*math.random()/2, -H/4 + H*math.random()/2 )
   prop:setRot( 600*math.random(), 180*math.random(), 90*math.random() )
   local scl = math.random()
   prop:setScl( scl,scl,scl)
   layer:insertProp ( prop )
   table.insert(cubes,prop)
end

print("rrr")

camera = MOAICamera3D.new ()
camera:setLoc ( 0, 0, camera:getFocalLength ( W ))
layer:setCamera ( camera )

print("zzz")


local t = MOAICoroutine.new()
t:run( function()
          while true do
             local chn = 2
             for i=1,chn do
                local i = math.floor( #cubes * math.random() )
                local p = cubes[1+i]
                local rng = 0.6
                p:seekLoc( (W * math.random() - W/2)*rng , (H*math.random() - H/2)*rng, 10 )
                local scl = math.random() * 1
                p:seekScl( scl, scl, scl, 8 * math.random() )
                p:moveRot ( 600*math.random(), 180, 90, math.random() * 10 )
             end
             
             coroutine.yield()
          end          
       end)