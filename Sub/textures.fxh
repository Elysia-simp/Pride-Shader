#define merge_strings(a,b) a##b 


texture diffuseTexture : MATERIALTEXTURE <>;
sampler diffuseSampler = sampler_state 
{
	texture = < diffuseTexture >;

	ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
};
texture DEFTexture : MATERIALSPHEREMAP<>;
sampler DEFSampler = sampler_state 
{
	texture = < DEFTexture >;
	ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
};
texture SDWTexture : MATERIALTOONTEXTURE<>;
sampler SDWSampler = sampler_state 
{
	texture = < SDWTexture >;
	ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
};
#ifdef lyr
texture LYRTexture : TEXTURE<
string ResourceName = merge_strings("lyr/", lyr);
>;
sampler LYRSampler = sampler_state 
{
	texture = < LYRTexture >;
	ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
};
#endif

#ifdef cubemap
texture CubeTexture : TEXTURE < 
string ResourceName = merge_strings("Cubemap/", cubemap);
string ResourceType = "Cube"; >;
samplerCUBE CubeSampler = sampler_state 
{
	TEXTURE = <CubeTexture>;
	MinFilter = LINEAR;
    	MagFilter = LINEAR;
   	MipFilter = LINEAR;
    	AddressU = Clamp;
    	AddressV = Clamp;
    	AddressW = Clamp;
};
#endif

#ifdef emi
texture emissionTexture : TEXTURE<
string ResourceName = merge_strings("Emi/", emi);
>;
sampler emissionSampler = sampler_state 
{
	texture = < emissionTexture >;
	ADDRESSU = CLAMP;
	ADDRESSV = CLAMP;
};
#endif
