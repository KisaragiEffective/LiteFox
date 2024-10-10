Shader "KisaragiMarine/LiteFox"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Offset ("Offset", Float) = 1.0
        _Hi ("Hi Color", Color) = (1.0, 1.0, 1.0)
        _Low ("Low Color", Color) = (1.0, 1.0, 1.0)
        _Pivot ("Pivot", Range(0.0, 1.0)) = 0.5
        _MaskTex ("Mask Texture", 2D) = "black" {}
        _WarpFactor ("Warp Factor", Float) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100
        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog
            #pragma multi_compile _ _BAKESHADER
            
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _Offset;
            float4 _Low;
            float4 _Hi;
            float _Pivot;
            sampler2D _MaskTex;
            float _WarpFactor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv: TEXCOORD0;
            };

            struct v2f
            {
                UNITY_FOG_COORDS(1)
                // 必要！！
                float4 vertex : SV_POSITION;
                float4 object_space_transform : COLOR;
                float2 main_uv: TEXCOORD0;
            };
            
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                #ifdef _BAKESHADER
                // FIXME: ちゃんと動かない :(
                float2 remappedUV = v.uv.xy * 2 - 1;
                float4 outputPos = float4(remappedUV.x, remappedUV.y, 0, 1);
                o.vertex = outputPos * float4(0, 0, 1, 0);
                #else
                o.vertex = UnityObjectToClipPos(v.vertex);
                #endif
                o.object_space_transform = v.vertex;
                o.main_uv = TRANSFORM_TEX(v.uv, _MainTex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                float edge_sense = 2 * abs(i.object_space_transform.z - 0.5);
                float a = i.object_space_transform.y - _Offset - _WarpFactor * edge_sense;
                float4 color = a > _Pivot ? _Hi : _Low;
                float4 base = tex2D(_MainTex, i.main_uv);
                float4 mask = tex2D(_MaskTex, i.main_uv);
                float4 color2 = lerp(float4(color.rgb, 1.0), float4(base.rgb, 1.0), 1 - mask.r);
                return color2;
            }
            ENDCG
        }
    }
}
