Shader "Custom/RenderToTexture_CA"
{
	Properties
	{
		_MainTex("Texture", 2D) = "white" {} 
    }
	SubShader
	{
		Tags { "RenderType" = "Opaque" }
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"
            
            uniform float4 _MainTex_TexelSize;
            sampler2D _MainTex;
            
			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv: TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 uv: TEXCOORD0;
			};
   
			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}
            
			fixed4 frag(v2f i) : SV_Target
			{
            
                float2 texel = float2(
                    _MainTex_TexelSize.x, 
                    _MainTex_TexelSize.y 
                );
               
                float cx = i.uv.x;
                float cy = i.uv.y;
                
                float4 C = tex2D( _MainTex, float2( cx, cy ));   
                
                float up = i.uv.y + texel.y * 1;
                float down = i.uv.y + texel.y * -1;
                float right = i.uv.x + texel.x * 1;
                float left = i.uv.x + texel.x * -1;
                
                float4 arr[8];
                
                arr[0] = tex2D(  _MainTex, float2( cx   , up ));   //N
                arr[1] = tex2D(  _MainTex, float2( right, up ));   //NE
                arr[2] = tex2D(  _MainTex, float2( right, cy ));   //E
                arr[3] = tex2D(  _MainTex, float2( right, down )); //SE
                arr[4] = tex2D(  _MainTex, float2( cx   , down )); //S
                arr[5] = tex2D(  _MainTex, float2( left , down )); //SW
                arr[6] = tex2D(  _MainTex, float2( left , cy ));   //W
                arr[7] = tex2D(  _MainTex, float2( left , up ));   //NW
                /*
                float3 orangeColor = float3(0.901,0.2,0.0);

                //count Blue neighbors
                int cB = 0;
                for(int i = 0;i<8;i++){
                    if(arr[i].b==1){cB++;}
                }
                
                //count Orange neighbors
                int cO = 0;
                for(int j =0; j<8;j++){
                    if(arr[j].r==0.901f){
                        cO++;}
                }
                
                int cG = 0;
                for(int p =0;p<8;p++){
                    if(arr[p].g==1){cG++;}
                }

                int cY =0;
                for(int n=0;n<8;n++){
                    if(arr[n].r==1.0){cY++;}
                }*/
                int cW =0;
                for(int g =0;g<8;g++){
                    if(arr[g].r==1){cW++;}
                }
                
                int cBlack = 0;
                for(int l = 0;l<8;l++){
                    if(arr[l].r==0 && arr[l].g==0){cBlack++;}
                }
                /*
                //rules: Can't die unless orange surrounded by orange
                //move to next color when next to blue and orange
                if(C.r == 0 && C.b == 0 && C.g == 0){//dead
                    if(cBlack > 0){return float4(0.0,1.0,0.0,1.0);}
                    else{return float4(0.0,0.0,0.0,1.0);}
                }
                else if(C.r == 0.901f){//orange
                    if(cO>0){return float4(0.0,0.0,0.0,1.0);}
                    else{return float4(0.901,0.2,0.0,1.0);}
                }
                else if(C.b == 1){//blue
                    if(cB> 0 ){return float4(0.901,0.2,0.0,1.0);}
                    else{return float4(0.0,0.0,1.0,1.0);}
                }
                else if(C.r == 1.0){//yellow
                    if(cY>0)return float4(0.0,0.0,1.0,1.0);//
                    else{return float4(0.0,1.0,0.0,1.0);}
                }
                else if(C.g == 1){//green
                    if(cG>0){ return float4(1.0,0.8,0.0,1.0);}//
                    else {return float4(0.0,0.0,0.0,1.0);}//
                }
                */
                float B1 = C.b - 0.1;
                float B2 = C.b + 0.1;
                if(C.r == 1){
                    if(cBlack ==1){return(float4(0.0,0.0,0.0,0.0));}
                    else if(cBlack >4){return float4(0.0,0.0,0.0,0.0);}
                    else{ return float4(1.0,1.0,1.0,1.0);}
                }
                else{
                    if(cW == 1){return(float4(1.0,1.0,1.0,1.0));}
                    if(cW > 4){return float4(1.0,1.0,1.0,1.0);}
                    else{return float4(0.0,0.0,0.0,0.0);}
                }
                //return float4(1.0,1.0,1.0,1.0);
                
                
            }

		ENDCG	
		}
	}
}