Shader "Custom/Properties"
{
    Properties
    {

        _IntegerVal("MyIntegerVal", Integer) = 10
        _StencilVal("StencilVal", Integer) = 0
        _FloatVal("MyFloatVal", Float) = 1.3
        _AlphaVal("AlphaVal", Range(0,1)) = 1
        _FloatRangeVal("MyFloatRangeVal", Range(0,10))= 2
        [MainTexture]_Texture2D("MyTexture2D", 2D) = "while"{}
        _Color("MyColor", Color) = (1,0,0,1)
        _Vector("MyVector", Vector) = (1,1,1,1)

    }
    
    //如过有多个SubShader，会从上往下找到第一个适配的SubShader执行
    SubShader
    {
        //控制SubShader是否可以执行：Shader.globalMaximumLOD = 300，那么高于300的子着色器无法使用
        //内置着色器LOD值最高300： Standard  等
        //LOD 600

        //Queue：渲染顺序，并不代表最终显式到屏幕上的顺序。Background  Geometry  AlphaTest  Transparent  Overlay
        //RenderPipeline: 告知Unity该SubShader适用于那种渲染管线。 UniversalPipeline 
        //RenderType:相当于SubShader名。
        //渲染时候，通过Camera.SetReplacementShader(Shader,"RenderType")或者Camera.RenderWithShader(Shader,"RenderType")来指定要渲染的Shader名
        Tags{"Queue"="Transparent" "RenderPipeline"="UniversalPipeline" "RenderType"="S1"}

        //所有的Pass都会依次执行
        Pass
        {
            //定义Pass的名字,通过C#代码可以控制Pass的使用等
            Name "S1_Pass1"
            //
            //Tags{"LightMode"="ForwardBase"}
            //Blend命令用于颜色混合，SrcAlpha值是片元着色器输出alpha值。使用条件 Queue=Transparent
            //Blend SrcAlpha OneMinusSrcAlpha
            //仅会向RGB通道写入颜色
            //ColorMask RGBA
            //剔除。
            //Cull Front
            //模板测试    如过测试通过则会进行后续的深度测试，如过通不过则GPU会丢弃该片元
            //模板测试是否通过计算公式：(Ref & ReadMask) Comp (stencilBufferValue & ReadMask)
            Stencil
            {
                Ref [_StencilVal]
                Comp Greater
                Pass Replace
            }



            HLSLPROGRAM
            //include必须包含在 HLSLPROGRAM里面
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            
            #pragma vertex vert
            #pragma fragment frag

            float _AlphaVal;
            float4 _Color;

            struct appdata
            {
                float3 pos : POSITION;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
            };

            v2f vert(appdata IN)
            {
                v2f OUT;
                OUT.pos = mul(UNITY_MATRIX_MVP, float4(IN.pos,1));
                return OUT;
            }

            float4 frag(v2f IN): SV_TARGET
            {
                return float4(_Color.r,_Color.g,_Color.b, _AlphaVal);
            }

            ENDHLSL
        }

       
    }

}
