using UnityEngine;
using System.Collections;

public class CSharpOut : MonoBehaviour {

	// Use this for initialization
	void Start () {

		float num1=2f,num2=3f;
		float multiply,sum;
		Calculate(num1,num2,out multiply,out sum);
		Debug.Log(multiply); //输出数值6
		Debug.Log (sum); //输出数值5

	}

	void Calculate(float num1,float num2, out float multiply,out float sum)
	{//将相乘结果和相加结果返回
		multiply=num1*num2;
		sum=num1+num2;
		
	}

}
