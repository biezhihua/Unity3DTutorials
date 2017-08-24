using UnityEngine;
using System.Collections;

public class MotionScript : MonoBehaviour {

	public float speed = 3f;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		transform.Translate(-Input.GetAxis("Horizontal") * speed * Time.deltaTime, 0, 0);
	
	}
}
