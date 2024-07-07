Shader "Dimenco/Color"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _DepthTex ("Depth Texture", 2D) = "white" {}
        _TopPad ("Top Padding", float) = 0.1
        _BottomPad ("Bottom Padding", float) = 0.1
        _PadTh ("Padding Threshold", float) = 0.9
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float depth : TEXCOORD1;
                UNITY_FOG_COORDS(2)
            };

            sampler2D _MainTex;
            sampler2D _DepthTex;
            float4 _MainTex_ST;
            float _TopPad;
            float _BottomPad;
            float _PadTh;
            UNITY_DECLARE_DEPTH_TEXTURE(_CameraDepthTexture);

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // o.depth = COMPUTE_DEPTH_01;
                COMPUTE_EYEDEPTH(o.depth);
                UNITY_TRANSFER_FOG(o,o.vertex);

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col;
                float checker;

                float d = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
                d = LinearEyeDepth(d);
                d = tex2D(_DepthTex, i.uv).x;

								// float depthDiff = i.depth - _PadTh;
                // checker = -(i.uv.y - (1 - _TopPad)) * (i.uv.y - _BottomPad) * (abs(depthDiff) - depthDiff);
                // clip(checker);

                col = (i.uv.y < (1 - _TopPad) &&
                      i.uv.y > _BottomPad) ||
                      d > _PadTh ?
                      tex2D(_MainTex, i.uv) :
                      float4(0, 0, 0, 0);

                // col = tex2D(_MainTex, i.uv);
                UNITY_APPLY_FOG(i.fogCoord, col);

                return col;
            }
            ENDCG
        }
    }
}
