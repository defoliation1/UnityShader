Shader "Unity Shaders Book/Chapter 6/DiffusePixel"
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
                fixed3 color : COLOR;
            };

            v2f vert(a2v v)
            {
                const float3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                const fixed3 worldNormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));

                const fixed3 diffuse = _LightColor0.rgb * _Diffuse.rgb * saturate(dot(worldNormal, lightDirection));
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.color = ambient + diffuse;
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 c = i.color;
                return fixed4(c, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}