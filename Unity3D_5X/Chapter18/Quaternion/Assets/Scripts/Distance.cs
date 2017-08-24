using UnityEngine;
using System.Collections;

public class Distance : MonoBehaviour {

	public Transform objTransform;

	// Use this for initialization
	void Start () {

		objTransform = GameObject.Find("Cube").GetComponent<Transform>(); //获取场景中
		if (objTransform) { //如果objTransform不为空则表示获取到组件
			var dist = Vector3.Distance(objTransform.position, transform.position); //使用Vector3.Distance来计算两个向量之间的距离
			Debug.Log("Distance: " + dist);
		}

	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
