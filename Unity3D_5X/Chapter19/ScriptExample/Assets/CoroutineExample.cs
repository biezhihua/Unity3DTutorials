using UnityEngine;
using System.Collections;

public class CoroutineExample : MonoBehaviour {
	
	// Use this for initialization
	IEnumerator Start ()
	{
		print ("Starting " + Time.time);
		yield return StartCoroutine(WaitAndPrint());
		print ("Done " + Time.time);
	}
	IEnumerator WaitAndPrint () {
		yield return new WaitForSeconds (5f);
		print ("WaitAndPrint "+ Time.time);
	}
}
