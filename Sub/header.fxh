//includes
#include <sub/textures.fxh>
#include <sub/controllers.fxh>
//less editing in the material value if i did this
bool use_subtexture;

//shit
float4x4 mmd_world : WORLD;
float4x4 mmd_view  : VIEW;
float4x4 mmd_wvp   : WORLDVIEWPROJECTION;
float4x4 mmd_p : PROJECTION;
float4x4 mmd_vp : VIEWPROJECTION;

//useful for scaling edgelines based on camera distance
float4x4 model_world : CONTROLOBJECT < string name = "(self)"; >;
float3 mmd_cameraPosition : POSITION < string Object = "Camera"; >;


//mmd RGB lighting intake
float4 egColor;

//mmd light source
float3 light_d : DIRECTION < string Object = "Light"; >;


float3 outline(float3 pos, float3 camera_pos, float3 normal, float outline_rate, float vertex_y, float vertex_x)
{   
    float3 offset_pos = 0;

    offset_pos.xyz = ((normalize(normal)) * (vertex_x * 0.013) ) + (pos);
    offset_pos.z = offset_pos.z + 0.0015;
    return offset_pos;
}
