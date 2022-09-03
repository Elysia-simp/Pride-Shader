//i separated everything so that if you wanted to study the shader all you had to do was look at each include individually
//rather than look at a huge ass mess

//includes
#include <sub/header.fxh>
#include <HgShadow_ObjHeader.fxh>
//
//atlas shit
float time_elapsed : TIME;
int frameNumber = 1;
int totalFrames = 4;
float animationSpeed = 1;

//base structure
struct vs_in
{
    float4 pos          : POSITION;
    float3 normal       : NORMAL;
    float2 uv            : TEXCOORD0;
    float2 uv2           : TEXCOORD1;
    float4 vertexcolor   : TEXCOORD2; 
};


struct vs_out
{
    float4 pos          : POSITION;
    float2 uv           : TEXCOORD0;
    float4 vertex       : TEXCOORD1;
    float3 normal       : TEXCOORD2;
    float3 view         : TEXCOORD3;
    float4 ppos         : TEXCOORD4; //hgshadow stuff idk if anything else uses ppos
    float2 uv2          : TEXCOORD5;
};

struct edge_out
{
    float4 pos : POSITION;
    float2 uv : TEXCOORD0;
    float4 texlod : TEXCOORD1;
    float3 normal : NORMAL;
    float4 vertex : TEXCOORD2;
};

vs_out vs_model ( vs_in i)
{
    vs_out o = (vs_out)0; //seriously stop writing OUT/IN in full
    //also could of used just vs_out o; but i use this to fix an error in unity and idfk if it affects mmd
    //but my other shaders work with this so deal with it lol
    o.pos = mul(i.pos, mmd_wvp);
    o.uv = i.uv;
    o.uv2 = i.uv2;
	o.normal = normalize(mul((float3x3) mmd_world, i.normal));
    o.view = mmd_cameraPosition - mul(i.pos.xyz, (float3x3)mmd_world);
    o.ppos = o.pos;
    return o;
}

edge_out vs_edge (vs_in i)
{
    float4 mView = mul(i.pos, mul(model_world, mmd_view));
    float viewDepth = mView.z / mView.w * 0.065;
    viewDepth = clamp(viewDepth, 0.03 , 5);
        if(mmd_p[3].w) // perspective check
    {
        viewDepth = 1.3; // perspective off
    } 
    edge_out o = (edge_out)0; //okay there was no excuse for the vertex shader
    //but this time it's to cheat and not have all of what VS needs in here as well
    o.vertex = i.vertexcolor;
    //i.pos.xyz = i.pos.xyz + i.normal * i.vertexcolor.w * 0.015 ;
    i.pos.xyz = outline(i.pos.xyz, mmd_cameraPosition, normalize(i.normal), 0.0015, i.vertexcolor.w * viewDepth);
    o.pos = mul(i.pos, mmd_wvp);
    return o;
}

float4 ps_edge(edge_out i) : COLOR0
{
    float4 color = float4(1,1,1,1);
    color.rgb = i.vertex.xyz;
    color.a = i.vertex.w;
    color.a = (color.a < 0.0001) ? 0 : 1;
    color *= egColor;
    return color;
}


float4 ps_model(vs_out i, float vface : VFACE) : COLOR0
{
    float comp = 1; //we are NOT using mmd's default ShadowMap use HgShadow
    if(HgShadow_Valid)
    {
        comp = HgShadow_GetSelfShadowRate(i.ppos);
    }

    //cause i know my ass isnt writing i.func all day
    float2 uv = i.uv;
    float2 uv2 = i.uv2; //miku only
    float3 view = normalize(i.view);
    float3 normal = i.normal;
    float3 reflvect = reflect(normal, view);//I put there here first even tho only the cube map uses it
    //I just want to make sure it's handled first before anything


    float4 color = float4(1, 1, 1, 1);


    float4 Tex = tex2D(diffuseSampler, uv); // alpha channel is stencil mask
    //just impliment in your shader of choice I really don't care lol

    float4 Def = tex2D(DEFSampler, uv); // r and g is also used to multiply with against the tangent
    //but asset ripper doesnt know what version this game uses no matter how I edited the file
    //so for now no tangents
    //that or bug asset studio dev to actually impliment tangent support

    float4 Sdw = tex2D(SDWSampler, uv); //I genuinely don't know what alpha here does 
    //I'm probably just stupid who knows wouldn't be news to 
    

    #ifdef cubemap
    float4 cube = texCUBE(CubeSampler, reflvect - Def.r); //obvious
    cube.a = 1;
    #endif

    //toon
    float3 ndotl = (dot(light_d, normal));

    if (use_subtexture){
    ndotl *= saturate(comp);
    }
    else if(!use_subtexture){
    light_d.y *= 0;
    light_d.z *= 3;
    }
    float lightsmooth = 1;
    if (Tex.a <= 0.8 && alpha == 0){ // hair uses a softer shadow for some reason but im in no position to argue lmfao
    
    lightsmooth = saturate(smoothstep(-0.12, 0.000000000025, (ndotl * (Def.r * 0.5)) + 0.05)); //i fucked up badly somewhere
    }
    else{
    lightsmooth = saturate(smoothstep(0, 0.000000000025, (ndotl * (Def.r * 0.5)) + 0.11));
    }
    lightsmooth = clamp (lightsmooth, 0, 1);
    color.a = 1;

    //specular
    float ndoth = dot(normal, view); 
    ndoth = clamp(ndoth, 0, 1);
    float S_Power = 1+SPow;
    float S_Bright = 1+SBright;
    float specularlight = pow(ndoth, 15 * S_Power) * Def.g * S_Bright;
    if (Tex.a <= 0.8 && alpha == 0){
    specularlight = saturate(smoothstep(0, 0.0025, specularlight));
    }
    else{
        specularlight = specularlight;
    }
    specularlight = clamp(specularlight, 0, 1);

    if(alpha == 1){
        color.a = Tex.a;
    }
    else if(alpha == 2){
    lightsmooth *= 0;
    color.a = Tex.a;
    }
    color.rgb = Tex.rgb;

    //rimlight
    float R_Power = 1+RPow;
    float R_Rate = 1+RRate;
    float R_Range = 1+RRange;
    float4 ndotv = saturate(1.0 + ROff - (pow(dot(normal, view), (1 * R_Rate))))* (1.5 * R_Power) * Def.b;
    if(alpha >= 1){
        ndotv *= Tex.a;
        specularlight = Tex.a;
    }

    float nor_rot = lerp(normal.y , normal.x, normalRot);

    ndotv *= nor_rot * R_Range;
    float4 rim_col = float4(Rim_R, Rim_G, Rim_B, 1.0);
    ndotv = smoothstep(0.2 - 0, 0.7 + 0.05, ndotv);



    //controller stuff
    float shadintensity = 1 + ShadowInt;
    shadintensity = clamp(shadintensity, 0, 5);

    //lerps
    if (use_subtexture){
    color.rgb = lerp(color.rgb, color.rgb + (color.rgb * specularlight), Def.a * Def.b * (1-lightsmooth));
    }
    color.rgb = lerp(color.rgb, Sdw.rgb, saturate(lightsmooth * shadintensity) );

    #ifdef cubemap
    if(Def.g >= 0.52f  && Def.g <= 0.8f){
    color += saturate(((cube * cube) * CubeEffectiveness) * Def.a );
    }
    if (Def.g >= 0.52f  && Def.g <= 0.8f && alpha >= 1){
    color += saturate(((cube * cube) * CubeEffectiveness) * Def.a * Tex.a);
    }
    #endif
    //atlas animation (miku only)
    frameNumber += frac(time_elapsed * animationSpeed) * totalFrames;
    float frame = clamp(frameNumber, 0 , totalFrames);
    float frameUpdate;
    float mod = modf(frame / 1, frameUpdate);

    float off = frameUpdate / 3;

    #ifdef atlas
    if (frameUpdate == 1) {
     uv2.x += 0.5;
    } 
    else if (frameUpdate == 2) {
    uv2.y += 0.5;
    }
    else if (frameUpdate == 3) {
    uv2.x += 0.5;
    uv2.y += 0.5;
    }
    #endif
    color *= egColor;
    color.rgb = lerp(color.rgb, color.rgb + (ndotv *(1+ rim_col)), ndotv * Def.b); //the game handles rgb colors externally for rimlight
    if(emi_type == 1){
    color += tex2D(emissionSampler, uv);
    }
    else if(emi_type == 2){
    uv.y += 0.5;
    color += tex2D(emissionSampler, uv2);
    }

    #ifdef glow
    if(emi_type ==2){
        uv = i.uv2;
    }
    color = tex2D(emissionSampler, uv) * 1.5;

    #endif
    return color;
}

technique model_SS_tech <string MMDPASS = "object_ss"; >
{
    pass main
    {
        alphablendenable = true;
        cullmode = ccw;
        #ifdef additive
        SrcBlend = SrcColor;
        DestBlend = ONE;
        #endif
        VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_model();

    }
    pass outline
    {
        cullmode = cw;
        VertexShader = compile vs_3_0 vs_edge();
        PixelShader = compile ps_3_0 ps_edge();
    }
}

technique model_tech <string MMDPASS = "object"; >
{
    pass main
    {
        alphablendenable = true;
        cullmode = ccw;
        #ifdef additive
        SrcBlend = SrcColor;
        DestBlend = ONE;
        #endif
        VertexShader = compile vs_3_0 vs_model();
        PixelShader = compile ps_3_0 ps_model();
    }
    pass outline
    {
        cullmode = cw;
        VertexShader = compile vs_3_0 vs_edge();
        PixelShader = compile ps_3_0 ps_edge();
    }
}
