// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 6/HaflLambert"
{
    Properties
    {
        _Diffuse ("Diffuse",Color) = (1.0,1.0,1.0,1.0)
    }
    SubShader
    {
        Pass
        {
            Tags
            {
                "LigthMode"="ForwardBase"
            }
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            fixed4 _Diffuse;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                const fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                const fixed halfLambert = dot(normalize(i.normal), lightDirection) * 0.5 + 0.5;
                const fixed3 color = _Diffuse * _LightColor0.xyz * halfLambert;
                return fixed4(ambient + color, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}