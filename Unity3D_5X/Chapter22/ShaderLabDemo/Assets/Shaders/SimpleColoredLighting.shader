Shader "Custom/Simple Colored Lighting" { // 名称
	Properties {
		// 定义一个名为Main Color的颜色属性
		_Color("Main Color", Color) = (1,0.5,0.5,1)
		_Vector("Main Vector", Vector) = (1,1,1,1)
		_Float("Main Float", Float) = 0.1
		_Range("Main Range", Range(1,5)) = 5
		_2D("Main 2D", 2D) =  ""
		_Rect("Main Rect", Rect ) = ""
		_Cube("Main Cube", Cube) = ""
	}

	// Shader的实现代码
	SubShader {
		Pass {
			Material {
				Diffuse [_Color]
			}
			Lighting On
			SetTexture [_2D] {}
		}
	}
}
