Shader "ShaderProj/s_properties" {

	Properties 
	{
		_float_value ("float_value",Float) = 0.1
		_int_value ("int_value", Int)= 2
		_rang_value ("range_value",Range (0,100)) = 0
		_color ("color",Color)= (1,1,1,1)
		_vector ("vector", Vector) = (1,1,1,1)
		//[NoScaleOffset]
		_texture ("texture", 2D) = "" {}
	}

	FallBack "Diffuse"
}
