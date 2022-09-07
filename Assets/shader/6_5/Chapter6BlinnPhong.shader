Shader "Unity Shaders Book/Chapter 6/BlinnPhong"
{
    Properties
    {
        _Diffuse ("Diffuse",Color) = (1.0,1.0,1.0,1.0)
        _Gloss ("Gloss",Range(8.0,256)) = 20
        _Specular ("Specular",Color) = (1,1,1,1)
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
            fixed4 _Specular;
            float _Gloss;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;
                const fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                const fixed3 color = _Diffuse * _LightColor0.xyz * saturate(dot(normalize(i.normal), lightDirection));
                const fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                const fixed3 halfDir = normalize(viewDir+lightDirection);
                const fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(
                    saturate(dot(halfDir, i.normal)), _Gloss);
                return fixed4(ambient + color + specular, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}