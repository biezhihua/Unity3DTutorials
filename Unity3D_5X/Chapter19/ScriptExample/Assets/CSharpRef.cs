using UnityEngine;
using System.Collections;

public class CSharpRef : MonoBehaviour {

	// Use this for initialization
	void Start () {

		int score=110;
		ClampScore(ref score);//传参数的引用
		Debug.Log(score);

	}
	
	void ClampScore(ref int num)
	{
		num=Mathf.Clamp(num,0,100); //限制值在0-100范围内容
	}

}
