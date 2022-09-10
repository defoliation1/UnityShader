Shader "Unity Shaders Book/Chapter 7/Simple Texture"
{
    Properties
    {
        _MainTex ("Main Tex",2D) = "white" {}
        _Color ("Diffuse",Color) = (1.0,1.0,1.0,1.0)
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

            fixed4 _Color;
            fixed4 _Specular;
            float _Gloss;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct a2v
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float3 normal : TEXCOORD0;
                float4 worldPos : TEXCOORD1;
                float2 uv: TEXCOORD2;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(UNITY_MATRIX_M, v.vertex);
                o.uv = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                return o;
            }


            fixed4 frag(v2f i) : SV_Target
            {
                fixed3 albedo = tex2D(_MainTex,i.uv).xyz * _Color.xyz;
                const fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
                const fixed3 lightDirection = normalize(_WorldSpaceLightPos0.xyz);
                fixed3 diffuse = albedo * _LightColor0.xyz * saturate(dot(normalize(i.normal),lightDirection));
                const fixed3 viewDir = normalize(_WorldSpaceCameraPos.xyz - i.worldPos.xyz);
                const fixed3 halfDir = normalize(viewDir+lightDirection);
                const fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(
                    saturate(dot(halfDir, i.normal)), _Gloss);
                return fixed4(ambient + diffuse + specular, 1.0);
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}