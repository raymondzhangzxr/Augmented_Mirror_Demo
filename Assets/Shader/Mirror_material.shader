Shader "Custom/Mirror"
{
    // This can be changed publically 
    Properties
    {
        // this is default white
        _Color("Color", Color) = (1,1,1,1)


        [Header(Reflections)]
    // Reflection:
    _Reflectivity("Reflectivity", Range(0, 1)) = 1
        // Fresnel Effect is the effect of differing reflectance on a surface depending on 
        // viewing angle, where as you approach the grazing angle more light is reflected. 
        _FresnelPower("Fresnel Power", Range(1, 5)) = 5
        // 0 is mirror 1, we can define four different mirrors
        [KeywordEnum(One, Two, Three, Four)]
            _PRID("Planar Refl. ID", Float) = 0
    }
        SubShader
            {
                Tags {
                    "RenderType" = "Transparent"
                    "Queue" = "Transparent"
                }

                Blend SrcAlpha OneMinusSrcAlpha
                ZWrite Off
                LOD 200

                CGPROGRAM

                #pragma surface surf Standard fullforwardshadows alpha:premul
                #pragma target 3.0        

                // Include the cginc files and do multi compile to have the ability
                // to render whichever ID chosen 
                // To enable planar reflections, enable _PRID_ONE, if the probe's
                // targeting ID 1
                #pragma multi_compile _PRID_ONE _PRID_TWO _PRID_THREE _PRID_FOUR
                #include "PlanarReflections.cginc"

                struct Input {
                    float4 screenPos;
                    float3 viewDir;
                };

                fixed4 _Color;
                half _Reflectivity;
                half _FresnelPower;

                sampler2D _CameraDepthTexture;
                float4 _CameraDepthTexture_TexelSize;

                UNITY_INSTANCING_BUFFER_START(Props)
                    // put more per-instance properties here
                UNITY_INSTANCING_BUFFER_END(Props)

                void surf(Input IN, inout SurfaceOutputStandard o) {

                    // We're not using these for still waters.
                    o.Metallic = 0;
                    o.Smoothness = 0;
                    o.Normal = float3(0, 0, 1);


                    // Let's calculate reflectivity based on foam and Fresnel.
                    half refl = _Reflectivity;
                    half cos = saturate(dot(o.Normal, normalize(IN.viewDir)));
                    refl += (1 - _Reflectivity) * pow(1 - cos, _FresnelPower);
                    // Sample the planar reflections and paint the pixel with it.
                    o.Emission = SamplePlanarReflections(IN.screenPos) * refl;
                }
                ENDCG
            }
                FallBack "Error"
}