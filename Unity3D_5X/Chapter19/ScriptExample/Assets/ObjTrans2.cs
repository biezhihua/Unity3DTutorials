using UnityEngine;
using System.Collections;

public class ObjTrans2 : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		var speed=30.0f;
		//Time.deltaTime表示距上一次调用所用的时间。
		transform.Rotate(Vector3.up * Time.deltaTime*speed); 
	}
}
