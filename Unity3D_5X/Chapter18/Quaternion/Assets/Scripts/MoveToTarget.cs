using UnityEngine;
using System.Collections;

public class MoveToTarget : MonoBehaviour {

	private Transform start; 
	private Transform end;

	// Use this for initialization
	void Start () {

		start = GameObject.Find("Cube").GetComponent<Transform>();
		end = GameObject.Find("GameObject").GetComponent<Transform>();	

	}
	
	// Update is called once per frame
	void Update () {

		transform.position =  Vector3.Lerp(start.position, end.position, Time.deltaTime);

	}
}
