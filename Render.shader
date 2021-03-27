Shader "Custom/Render"
{
 Properties {
			 _MainTex("_MainTex1", 2D) = "white" {}		
			_Flowmap ("Flowmap", 2D) = "white" {}		
			
			_RSpeed("RotateSpeed", Range(0, 100)) = 0.5	//旋转速度
			duration("RotateSpeed", Range(0, 2)) =1
	}
	SubShader {
	Tags { }    	
		Pass{
		
			Cull off //双面都显示
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
		
			sampler2D _MainTex; //变量使用前声明
			sampler2D _Flowmap; //变量使用前声明
			float _RSpeed;
			float duration;
			
			struct v2f{		
				float4 pos:POSITION; 
				float4 uv:TEXCOORD0;
			};
		
			v2f vert(appdata_base v){
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;								
				return o;
			}
			
			float4 getLayer(float2 uv, float t)
			{
                float4 f =tex2D(_Flowmap,uv)*2-1;
                return tex2D(_MainTex,uv-f.xy*t*_RSpeed);	
			}
		
			half4 frag(v2f IN):COLOR{
             
            float t = _Time.y/duration;
            float t0 =t %2;
            float t1 =(t+1)%2;
            float w =abs(t%2-1);
            float4 c0=getLayer(IN.uv,t0);
            float4 c1=getLayer(IN.uv,t1);
            return lerp(c0,c1,w);
    
			}
			
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
