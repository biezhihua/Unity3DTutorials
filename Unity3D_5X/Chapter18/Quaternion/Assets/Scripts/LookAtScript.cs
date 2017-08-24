using UnityEngine;
using System.Collections;

public class LookAtScript : MonoBehaviour {

	public Transform target;

	// Use this for initialization
	void Start () {

		target = GameObject.Find ("Sphere").transform;
	
	}
	
	// Update is called once per frame
	void Update () {

		Vector3 relativePos = target.position - transform.position;
		transform.rotation = Quaternion.LookRotation(relativePos);

	}
}
