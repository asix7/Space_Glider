// Copyright (c) 2010-2012 SharpDX - Alexandre Mutel
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
// Adapted for COMP30019 by Jeremy Nicholson, 10 Sep 2012
// Adapted further by Chris Ewin, 23 Sep 2013

// these won't change in a given iteration of the shader

#define MAX_LIGHTS 3

struct Light
{
	float4 lightPos;
	float4 lightCol;
};

// TASK 2: These are no longer hard coded
float4 lightAmbCol;

// TASK 4 & 6: Here we take an array of lights
Light lights[MAX_LIGHTS];

float4x4 World;
float4x4 View;
float4x4 Projection;
float4 cameraPos;
float4x4 worldInvTrp;
//

texture2D ModelTexture;
SamplerState SampleType;

struct VS_IN
{
	float4 pos : SV_POSITION;
	float4 nrm : NORMAL;
	float2 tex : TEXCOORD0;
// Other vertex properties, e.g. texture co-ords, surface Kd, Ks, etc
};

struct PS_IN
{
	float4 pos : SV_POSITION; //Position in camera co-ords
	float2 tex : TEXCOORD0;
	float4 wpos : TEXCOORD1; //Position in world co-ords
	float3 wnrm : TEXCOORD2; //Normal in world co-ords 
};


PS_IN VS( VS_IN input )
{
	PS_IN output = (PS_IN)0;

	// Convert Vertex position and corresponding normal into world coords
	// Note that we have to multiply the normal by the transposed inverse of the world 
	// transformation matrix (for cases where we have non-uniform scaling; we also don't
	// care about the "fourth" dimension, because translations don't affect the normal)
	output.wpos = mul(input.pos, World);
	output.wnrm = mul(input.nrm.xyz, (float3x3)worldInvTrp);

	// Transform vertex in world coordinates to camera coordinates
	float4 viewPos = mul(output.wpos, View);
    output.pos = mul(viewPos, Projection);

	// Just pass along the colour at the vertex
	output.tex = input.tex;

	return output;
}

float4 PS( PS_IN input ) : SV_Target
	{
	// Our interpolated normal might not be of length 1
	float3 interpNormal = normalize(input.wnrm);

	float4 textureColor = ModelTexture.Sample(SampleType, input.tex);

	// Calculate ambient RGB intensities
	float Ka = 1;
	float3 amb = textureColor.rgb*lightAmbCol.rgb*Ka;

	float4 returnCol = float4(0.0f, 0.0f, 0.0f, 0.0f);
	returnCol.rgb = amb.rgb;
	returnCol.a = textureColor.a;

	// TASK 4: When working with multiple lights, simply sum the diffuse and specular components of all light sources
	for (int i = 0; i < MAX_LIGHTS; i++) {
		// Calculate diffuse RBG reflections
		float fAtt = 1;
		float Kd = 1;
		float3 L = normalize(lights[i].lightPos.xyz - input.wpos.xyz);
		float LdotN = saturate(dot(L, interpNormal.xyz));
		float3 dif = fAtt*lights[i].lightCol.rgb*Kd*textureColor.rgb*LdotN;

		// Calculate specular reflections
		float Ks = 1;
		float specN = 5; // Numbers>>1 give more mirror-like highlights
		float3 V = normalize(cameraPos.xyz - input.wpos.xyz);
		float3 R = normalize(2 * LdotN*interpNormal.xyz - L.xyz);
		//float3 R = normalize(0.5*(L.xyz+V.xyz)); //Blinn-Phong equivalent
		float3 spe = fAtt*lights[i].lightCol.rgb*Ks*pow(saturate(dot(V, R)), specN);
		returnCol.rgb = returnCol.rgb + dif.rgb + spe.rgb;
	}
	return returnCol;
}



technique Lighting
{
    pass Pass1
    {
		Profile = 10;
        VertexShader = VS;
        PixelShader = PS;
    }
}