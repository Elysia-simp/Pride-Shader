//base

#define alpha 0 //0: none 1: regular alpha 2: eyes
//#define atlas //only miku's 15th anniversary outfit uses this as far as i know
#define emi_type 0 // 0: off 1: on 2: uv2
#define emi "test.png"
//#define lyr "test.png" 


//cubemap

//#define cubemap "test.dds" //make your own
#define CubeEffectiveness 1

//specular

#define base_specpow 1

//extra

//#define additive // eyelights only Kotone has alpha's thought for whatever reason
//#define glow //This was made with Manashiku's PostGow shader
//#define tangent_outline //models exported with unity will have tangents and they use it like this
//however with the state mmd's in with tangents i can only provide it for outlines at this time

//debugging

//#define debug 0 //0: off 1:diffuse only 2: Def.r 3: Def.g 4: Def.b 5: Sdw.rgb 6: Sdw.a 7: Tex.a
//for some reason this breaks for people
//idk if it's a me thing or not but this is disabled by default

#include <shader.fxh>
