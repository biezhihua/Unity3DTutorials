using UnityEngine;
using System.Collections;

public class ObjTrans1 : MonoBehaviour {

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {

		var speed=2.0f;
		transform.Translate(Vector3.forward * Time.deltaTime* speed); 


	}
}
