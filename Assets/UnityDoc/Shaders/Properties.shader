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
    
    //����ж��SubShader������������ҵ���һ�������SubShaderִ��
    SubShader
    {
        //����SubShader�Ƿ����ִ�У�Shader.globalMaximumLOD = 300����ô����300������ɫ���޷�ʹ��
        //������ɫ��LODֵ���300�� Standard  ��
        //LOD 600

        //Queue����Ⱦ˳�򣬲�������������ʽ����Ļ�ϵ�˳��Background  Geometry  AlphaTest  Transparent  Overlay
        //RenderPipeline: ��֪Unity��SubShader������������Ⱦ���ߡ� UniversalPipeline 
        //RenderType:�൱��SubShader����
        //��Ⱦʱ��ͨ��Camera.SetReplacementShader(Shader,"RenderType")����Camera.RenderWithShader(Shader,"RenderType")��ָ��Ҫ��Ⱦ��Shader��
        Tags{"Queue"="Transparent" "RenderPipeline"="UniversalPipeline" "RenderType"="S1"}

        //���е�Pass��������ִ��
        Pass
        {
            //����Pass������,ͨ��C#������Կ���Pass��ʹ�õ�
            Name "S1_Pass1"
            //
            //Tags{"LightMode"="ForwardBase"}
            //Blend����������ɫ��ϣ�SrcAlphaֵ��ƬԪ��ɫ�����alphaֵ��ʹ������ Queue=Transparent
            //Blend SrcAlpha OneMinusSrcAlpha
            //������RGBͨ��д����ɫ
            //ColorMask RGBA
            //�޳���
            //Cull Front
            //ģ�����    �������ͨ�������к�������Ȳ��ԣ����ͨ������GPU�ᶪ����ƬԪ
            //ģ������Ƿ�ͨ�����㹫ʽ��(Ref & ReadMask) Comp (stencilBufferValue & ReadMask)
            Stencil
            {
                Ref [_StencilVal]
                Comp Greater
                Pass Replace
            }



            HLSLPROGRAM
            //include��������� HLSLPROGRAM����
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
